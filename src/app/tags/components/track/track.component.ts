import { Component, OnInit, OnDestroy } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { ActivatedRoute, Router } from '@angular/router';
import { Subscription } from 'rxjs';
import { TaggedTrack } from '../../models/tagged-track.model';
import { TagService } from '../../services/tag.service';

@Component({
  selector: 'app-track',
  templateUrl: './track.component.html',
  styleUrls: ['./track.component.scss'],
})
export class TrackComponent implements OnInit, OnDestroy {
  routeSub: Subscription = new Subscription();
  spotifyRedirection = 'https://open.spotify.com/track/';
  value = '';

  constructor(
    private router: Router,
    private readonly route: ActivatedRoute,
    private readonly tagService: TagService,
    private snackbar: MatSnackBar
  ) {}

  tagtrack: TaggedTrack | null = null;

  tagNames: string[] = [];

  suggestionTags: string[] = [];

  ngOnInit(): void {
    this.routeSub = this.route.url.subscribe(async (url) => {
      const id = url[1].path;
      if (id) {
        Promise.all([
          this.tagService.getSuggestions({ trackId: id }),
          this.tagService.getTagNames(),
        ]).then((result) => {
          this.tagNames = result[1].tagNames;
          this.suggestionTags = result[0];
        });

        this.tagtrack = await this.tagService.getTaggedTrackByTrackId({
          trackId: id,
        });
        this.spotifyRedirection += this.tagtrack.track.spotifyTrack.spotifyId;
      } else {
        this.snackbar.open('get TaggedTrack fail', 'Close', {
          duration: 2000,
          horizontalPosition: 'right',
          verticalPosition: 'top',
        });
      }
    });
  }

  goBack() {
    this.router.navigate(['/']);
  }

  ngOnDestroy(): void {
    this.routeSub.unsubscribe();
  }

  onChipChange(value: string) {
    if (this.tagtrack?.track) {
      if (!this.tagtrack?.tags.includes(value)) {
        this.tagService.addTag({
          body: { tag: value, trackId: this.tagtrack.track.id },
        });
      } else {
        this.tagService.deleteTag({
          body: { tag: value, trackId: this.tagtrack.track.id },
        });
      }
    }
    if (this.tagtrack?.tags.includes(value)) {
      this.tagtrack.tags = this.tagtrack?.tags.filter((val) => val !== value);
    } else {
      this.tagtrack?.tags.push(value);
    }
  }

  onSuggestionChipChange(value: string) {
    this.onChipChange(value);
    if (!this.tagNames.includes(value)) {
      this.tagNames.push(value);
    }
  }

  addTag() {
    const input = this.value.trim();
    if (input === '') {
      this.snackbar.open('empty tag', 'Close', {
        duration: 2000,
        horizontalPosition: 'right',
        verticalPosition: 'top',
      });
      return;
    }
    if (input !== '' && !this.tagtrack?.tags.includes(input)) {
      if (this.tagtrack?.track) {
        this.onChipChange(input);
        this.tagtrack.tags.push(input);
        if (!this.tagNames.includes(input)) {
          this.tagNames.push(input);
        }

        this.value = '';
      }
    } else {
      this.snackbar.open('tag already selected', 'Close', {
        duration: 2000,
        horizontalPosition: 'right',
        verticalPosition: 'top',
      });
    }
  }
}
