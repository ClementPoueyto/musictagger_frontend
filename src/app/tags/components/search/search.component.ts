import {
  Component,
  HostListener,
  OnInit,
  OnDestroy,
  AfterViewChecked,
} from '@angular/core';
import { Router } from '@angular/router';
import { DataSource } from '@angular/cdk/collections';
import { TaggedTrack } from '../../models/tagged-track.model';
import { Observable, ReplaySubject, Subject, Subscription } from 'rxjs';
import {
  LikeTaggedTrackRequest,
  SearchTaggedTrackRequest,
} from '../../services/tag-request.interface';
import { Metadata } from '../../models/metadata.model';
import { PageEvent } from '@angular/material/paginator';
import { debounceTime, distinctUntilChanged } from 'rxjs/operators';
import { FilterDialogComponent } from './filter-dialog/filter-dialog.component';
import { MatDialog } from '@angular/material/dialog';
import { TagService } from '../../services/tag.service';
import { UserService } from 'src/app/shared/services/user.service';
@Component({
  selector: 'app-search',
  templateUrl: './search.component.html',
  styleUrls: ['./search.component.scss'],
})
export class SearchComponent implements OnInit, OnDestroy, AfterViewChecked {
  displayedColumns: string[] = ['photo', 'title', 'artist', 'album', 'tags'];
  dataToDisplay = [];

  dataSource = new TrackDataSource(this.dataToDisplay);
  nbTagsToDisplay = 0;
  selectedChip: 'tags' | 'like';

  query = '';
  allowScrolling = false;
  tags: string[] = [];
  metadata: Metadata = { page: 0, limit: 50 };
  availableChips = [
    { name: 'tags', display: 'Tags', selected: false },
    { name: 'like', display: 'Spotify Likes', selected: false },
  ];

  searchUpdate = new Subject<string>();

  userSub: Subscription = new Subscription();
  searchSub: Subscription = new Subscription();

  constructor(
    private readonly tagService: TagService,
    private readonly userService: UserService,
    private readonly router: Router,
    public dialog: MatDialog
  ) {
    this.query = tagService.query;
    this.metadata = tagService.metadata;
    this.selectedChip = tagService.selectedChip;
    this.tags = tagService.tags;
    this.availableChips.filter(
      (chip) => chip.name === tagService.selectedChip
    )[0].selected = true;
  }

  ngAfterViewChecked(): void {
    if (this.allowScrolling) {
      const element = document.getElementById(
        this.tagService.lastIdTrackSelected
      );
      element?.scrollIntoView({ block: 'center' });
      this.allowScrolling = false;
    }
  }

  ngOnInit(): void {
    this.onWindowResize();
    this.searchSub = this.searchUpdate
      .pipe(debounceTime(400), distinctUntilChanged())
      .subscribe(() => {
        this.getData({
          key: this.selectedChip,
          request: {
            page: this.metadata.page,
            limit: this.metadata.limit,
            query: this.query,
            tags: this.tags,
          },
        });
      });

    this.userSub = this.userService.currentUser.subscribe(async (user) => {
      if (user && user.spotifyUser) {
        this.getData({
          key: this.selectedChip,
          request: {
            page: this.metadata.page,
            limit: this.metadata.limit,
            query: this.query,
            tags: this.tags,
          },
        }).then(() => {
          this.allowScrolling = true;
        });
      }
    });
  }

  ngOnDestroy(): void {
    this.userSub.unsubscribe();
    this.searchSub.unsubscribe();
  }

  onWindowSizeChanging(width: number, height: number) {
    if (width >= 700) {
      this.nbTagsToDisplay = 10;
      this.displayedColumns = ['photo', 'title', 'artist', 'album', 'tags'];
    }
    if (width >= 1000) {
      this.nbTagsToDisplay = 20;
      this.displayedColumns = ['photo', 'title', 'artist', 'album', 'tags'];
    }
    if (width < 700) {
      this.displayedColumns = ['photo', 'title', 'artist', 'tags'];
      this.nbTagsToDisplay = 5;
    }
    if (width < 500) {
      this.displayedColumns = ['photo', 'title', 'tags'];
      this.nbTagsToDisplay = 4;
    }
    if (width < 350) {
    }
  }

  onChipChange($event: any) {
    this.selectedChip = $event.value.trim();
    this.dataSource.setData([]);
    this.metadata = { total: 0, limit: this.tagService.metadata.limit, page: 0 };
    this.getData({
      key: this.selectedChip,
      request: { page: 0, limit: this.tagService.metadata.limit, query: this.query, tags: this.tags },
    });
  }

  onFilterChipChange($event: any, tag: string) {
    if (!$event.selected) {
      this.tags = this.tags.filter((val) => val != tag);
      this.onFilterChange();
    }
  }

  getData(param: {
    key: 'tags' | 'like';
    request: { page: number; limit: number; query?: string; tags?: string[] };
  }) {
    if (param.key === 'tags') {
      return this.tagService
        .searchTaggedTrack(param.request as SearchTaggedTrackRequest)
        .then((res) => {
          this.dataSource.setData(res.data);
          this.metadata = res.metadata;
        });
    }
    if (param.key === 'like') {
      return this.tagService
        .getLikeTaggedTrack(param.request as LikeTaggedTrackRequest)
        .then((res) => {
          this.dataSource.setData(res.data);
          this.metadata = res.metadata;
        });
    }

    return Promise.resolve();
  }

  handlePaginatorEvent($event: PageEvent) {
    this.tagService.metadata = { limit: $event.pageSize, page: $event.pageIndex};
    this.getData({
      key: this.selectedChip,
      request: {
        page: $event.pageIndex,
        limit: $event.pageSize,
        query: this.query,
        tags: this.tags,
      },
    });
  }

  onClickRow(row: TaggedTrack) {
    this.tagService.lastIdTrackSelected = row.track.id.toString();
    this.router.navigate(['/tracks/' + row.track.id]);
  }
  applySearch(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.query = filterValue;
    this.searchUpdate.next(filterValue);
  }

  @HostListener('window:resize', ['$event'])
  onWindowResize() {
    this.onWindowSizeChanging(window.innerWidth, window.innerHeight);
  }

  clearSearch() {
    this.query = '';
    this.searchUpdate.next(this.query);
  }

  openFilterDialog() {
    const filterDialog = this.dialog.open(FilterDialogComponent, {
      minWidth: '300px',
      data: {
        selected: this.tags,
      },
    });
    filterDialog.afterClosed().subscribe((result) => {
      if (result) {
        this.tags = result;
        this.onFilterChange();
      }
    });
  }

  onFilterChange() {
    this.getData({
      key: this.selectedChip,
      request: {
        page: 0,
        limit: this.metadata.limit,
        query: this.query,
        tags: this.tags,
      },
    });
  }
}

class TrackDataSource extends DataSource<TaggedTrack> {
  private _dataStream = new ReplaySubject<TaggedTrack[]>();

  constructor(initialData: TaggedTrack[]) {
    super();
    this.setData(initialData);
  }

  connect(): Observable<TaggedTrack[]> {
    return this._dataStream;
  }

  disconnect() {
    this._dataStream.complete();
  }

  setData(data: TaggedTrack[]) {
    this._dataStream.next(data);
  }
}
