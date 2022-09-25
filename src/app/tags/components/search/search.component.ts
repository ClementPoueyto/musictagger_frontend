import { Component, EventEmitter, HostListener, OnInit, OnDestroy } from '@angular/core';
import { LOCALSTORAGE_TOKEN_KEY } from 'src/app/app.module';
import { Router } from '@angular/router';
import { DataSource } from '@angular/cdk/collections';
import { TaggedTrack } from '../../models/tagged-track.model';
import {Observable, ReplaySubject, Subject,Subscription} from 'rxjs';
import { TagService } from '../../services/tag.service';
import { UserService } from '../../services/user.service';
import { LikeTaggedTrackRequest, SearchTaggedTrackRequest } from '../../services/tag.interface';
import { Metadata } from '../../models/metadata.model';
import { PageEvent } from '@angular/material/paginator';
import { debounceTime, distinctUntilChanged, map } from 'rxjs/operators';
@Component({
  selector: 'app-search',
  templateUrl: './search.component.html',
  styleUrls: ['./search.component.scss']
})
export class SearchComponent implements OnInit,OnDestroy {

  displayedColumns: string[] = ['photo', 'title', 'artist','album', 'tags'];
  dataToDisplay = [];

  dataSource = new TrackDataSource(this.dataToDisplay);

  selectedChip : 'like' | 'tags' = 'like'

  query : string = "";

  metadata : Metadata = {total : 0, page : 0, limit : 50}
  availableChips = [
    { name: 'like', display : "Spotify Likes", selected: true },
    { name: 'tags', display : "Tags", selected: false },

  ];

  searchUpdate = new Subject<string>();

  userSub : Subscription = new Subscription();
  searchSub : Subscription = new Subscription();

  constructor(private readonly tagService : TagService,private readonly userService : UserService, private readonly router : Router ) {
      this.query = tagService.query;
      this.metadata = tagService.metadata;
      this.selectedChip = tagService.selectedChip;
      if(tagService.selectedChip == 'tags') this.availableChips = [
        { name: 'like', display : "Spotify Likes",selected: false },
        { name: 'tags', display : "Tags",selected: true },
    
      ];
      
        
      
    
     }

     ngOnInit(): void {
      this.onWindowResize();
      this.searchSub = this.searchUpdate.pipe(
        debounceTime(400),
        distinctUntilChanged())
        .subscribe(value => {
          const token = localStorage.getItem(LOCALSTORAGE_TOKEN_KEY);
          if(token)
          this.getData({key : this.selectedChip, request : { jwt_token : token, page : this.metadata.page, limit : this.metadata.limit, query : this.query}})

        });

        this.userSub = this.userService.currentUser.subscribe(
          user=>{
            console.log(user)
            const token = localStorage.getItem(LOCALSTORAGE_TOKEN_KEY);
            if(token&&user&&user.spotifyUser){
              this.getData({key : this.selectedChip, request : { jwt_token : token, page : this.tagService.metadata.page, limit : this.tagService.metadata.limit, query : this.query}})
            }
          }
        )
    }

    ngOnDestroy() : void{
      this.userSub.unsubscribe();
      this.searchSub.unsubscribe();
    }
  
    onWindowSizeChanging(width : number, height : number){
      if(width<500){
        this.displayedColumns = ['photo', 'title', 'artist', 'tags'];
      }
      else{
        this.displayedColumns = ['photo', 'title', 'artist', 'album','tags'];
      }
    }

  onChipChange($event: any) {
    this.selectedChip = $event.value.trim()

    const token = localStorage.getItem(LOCALSTORAGE_TOKEN_KEY);
    if(token){
      this.metadata = { total : 0, limit : 50, page : 0}
      this.getData({key :this.selectedChip, request : { jwt_token : token, page : 0, limit : 50, query : this.query}})
    }

  }

  getData(param : {key : "tags" | "like", request : {jwt_token : string, page : number; limit : number, query? : string, tags? : string[]}} ){
    if(param.key == 'tags' ){

      this.tagService.searchTaggedTrack(param.request as SearchTaggedTrackRequest ).then(
        res=> {
          this.dataSource.setData(res.data);
          this.metadata = res.metadata
        }
      );
    }
    if(param.key == 'like'){

      this.tagService.getLikeTaggedTrack(param.request as LikeTaggedTrackRequest).then(
        res=> {
          this.dataSource.setData(res.data)
          this.metadata = res.metadata
        }
      );
    }
  }

  handlePaginatorEvent($event: PageEvent){
    const token = localStorage.getItem(LOCALSTORAGE_TOKEN_KEY);
    if(token){
      this.getData({key : this.selectedChip, request : { jwt_token : token, page : $event.pageIndex, limit : $event.pageSize, query : this.query}})

    }
  }

  onClickRow (row : TaggedTrack){
    this.router.navigate(['tags/tracks/'+row.track.id]);
  }
  applySearch(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.query = filterValue
    this.searchUpdate.next(filterValue)

  }

  @HostListener('window:resize', ['$event'])
  onWindowResize() {
    
    this.onWindowSizeChanging(window.innerWidth,
      window.innerHeight);
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

  disconnect() {}

  setData(data: TaggedTrack[]) {
    this._dataStream.next(data);
  }
}
