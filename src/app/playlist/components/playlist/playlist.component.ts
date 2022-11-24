import { Component, Input, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { User } from 'src/app/shared/models/user.model';
import { Playlist } from '../../models/playlist.model';
import { PlaylistService } from '../../services/playlist.service';
import { Observable, ReplaySubject, Subscription } from 'rxjs'
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { EditPlaylistComponent } from '../edit-playlist/edit-playlist.component';
import { MatDialog } from '@angular/material/dialog';
import { DeletePlaylistComponent } from '../delete-playlist/delete-playlist.component';
import { Track } from 'src/app/tags/models/track.model';
import { DataSource } from '@angular/cdk/collections';
import { Metadata } from '../../services/playlist.interface';
import { PageEvent } from '@angular/material/paginator';

@Component({
  selector: 'app-playlist',
  templateUrl: './playlist.component.html',
  styleUrls: ['./playlist.component.scss']
})
export class PlaylistComponent {

  playlist: Playlist | null = null;

  @Input()
  user: User | null = null;

  routeSub: Subscription = new Subscription();

  editForm: FormGroup = new FormGroup({
    title: new FormControl("", [Validators.required]),
    description: new FormControl("",),
  });
  nbTagsToDisplay = 50;
  displayedColumns: string[] = ['photo', 'title', 'artist', 'album'];
  dataToDisplay = [];
  metadata: Metadata = { total: 0, page: 0, limit: 50 }
  dataSource = new PlaylistTracksDataSource(this.dataToDisplay);

  displayLoader = true;

  constructor(private playlistService: PlaylistService, private route: ActivatedRoute, private router: Router, private dialog: MatDialog) {
    this.routeSub = this.route.url.subscribe(url => {
      const id = Number(url[0].path)
      if (id) {
   
          this.playlistService.getPlaylistById({ playlist_id: id }).then(
            playlist => {
              if (playlist) {
                this.playlist = playlist
              }
              this.getTracksData()
            }
          )

        
      }
    })

  }

  getTracksData() {
    if (this.playlist) {
      this.playlistService.getPlaylistTracksById({ playlist_id: Number(this.playlist.id), page: this.metadata.page, limit: this.metadata.limit }).then(tracks => {
        if (tracks) {
          this.dataSource.setData(tracks.data);
          this.metadata = tracks.metadata
        }
      })
    }
  }

  handlePaginatorEvent($event: PageEvent) {
    this.metadata = { limit: $event.pageSize, total: this.metadata.total, page: $event.pageIndex }
    this.getTracksData()


  }
  editDialog() {
    if (this.playlist) {
      const editDialog = this.dialog.open(EditPlaylistComponent, {
        minWidth: '300px',
        height : '90%',
        disableClose: true,
        data: {
          mode: 'edit',
          selected: this.playlist.tags,
          title: this.playlist.name,
          description: this.playlist.description,
          id: this.playlist.id
        }
      });
      editDialog.afterOpened().subscribe(() => {
        this.displayLoader = false;
      })
      editDialog.afterClosed().subscribe(result => {
        this.displayLoader = true;
        if (result == 'refresh') {
          if (this.playlist) {
            this.playlistService.getPlaylistById({ playlist_id: Number(this.playlist.id) }).then(
              playlist => { if (playlist) this.playlist = playlist }
            )

          }
        }

      });
    }

  }

  goBack() {
    this.router.navigate(["../export"])
  }

  deleteDialog() {
    const deleteDialog = this.dialog.open(DeletePlaylistComponent, {
      minWidth: '300px',
    })
    deleteDialog.afterClosed().subscribe(res => {
      if (res == 'confirm') {
        if (this.playlist) {
          this.playlistService.deletePlaylist({ playlist_id: Number(this.playlist!.id) }).then(() => {
            this.router.navigate(["../export"])
          })
        }
      }
    })
  }


}

class PlaylistTracksDataSource extends DataSource<Track> {
  private _dataStream = new ReplaySubject<Track[]>();

  constructor(initialData: Track[]) {
    super();
    this.setData(initialData);
  }

  connect(): Observable<Track[]> {
    return this._dataStream;
  }

  disconnect() { 
    this._dataStream.complete();
  }

  setData(data: Track[]) {
    this._dataStream.next(data);
  }
}