import { Component, Input, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { LOCALSTORAGE_TOKEN_KEY } from 'src/app/app.module';
import { User } from 'src/app/tags/models/user.model';
import { Playlist } from '../../models/playlist.model';
import { PlaylistService } from '../../services/playlist.service';
import { Observable, ReplaySubject, Subscription } from 'rxjs'
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { Dialog } from '@angular/cdk/dialog';
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
export class PlaylistComponent implements OnInit {

  playlist : Playlist | null = null;

  @Input()
  user : User| null = null;

  routeSub : Subscription = new Subscription();

  editForm: FormGroup = new FormGroup({
    title: new FormControl("", [Validators.required]),
    description: new FormControl("",),
  });
  nbTagsToDisplay : number = 50;
  displayedColumns: string[] = ['photo', 'title' , 'artist', 'album'];
  dataToDisplay = [];
  metadata : Metadata = {total : 0, page : 0, limit : 50}
  dataSource = new PlaylistTracksDataSource(this.dataToDisplay);

  displayLoader : boolean = true;

  constructor(private playlistService : PlaylistService, private route : ActivatedRoute, private router : Router,private dialog : MatDialog) { 
    this.routeSub = this.route.url.subscribe(url=>{
      const id : number = Number(url[0].path)
      if(id){
        const token = localStorage.getItem(LOCALSTORAGE_TOKEN_KEY)
        if(token){
          this.playlistService.getPlaylistById({jwt_token : token, playlist_id : id}).then(
            playlist => {
              if(playlist){
                this.playlist = playlist
              } 
              this.getTracksData()
            }
          )

        }
      }
    })
    
  }

  ngOnInit(): void {
    
  }

  getTracksData(){
    const token = localStorage.getItem(LOCALSTORAGE_TOKEN_KEY)
    if(this.playlist&&token){
    this.playlistService.getPlaylistTracksById({jwt_token : token, playlist_id : Number(this.playlist.id), page : this.metadata.page, limit : this.metadata.limit }).then(tracks=>{
      if(tracks){
        this.dataSource.setData(tracks.data);
        this.metadata = tracks.metadata
      }
    })
  }
}

handlePaginatorEvent($event: PageEvent){
  this.metadata = { limit : $event.pageSize, total : this.metadata.total, page : $event.pageIndex}
    this.getTracksData( )


}
  editDialog(){
    if(this.playlist){
      const editDialog = this.dialog.open(EditPlaylistComponent,{
        minWidth: '300px',
        disableClose : true,
        data: {
          mode : 'edit',
          selected: this.playlist.tags,
          title : this.playlist.name,
          description : this.playlist.description,
          id : this.playlist.id
      }
       });
       editDialog.afterOpened().subscribe(()=>{
        this.displayLoader = false;
      })
       editDialog.afterClosed().subscribe(result => {
        this.displayLoader = true;
        if(result=='refresh'){
          const token = localStorage.getItem(LOCALSTORAGE_TOKEN_KEY)
        if(token&&this.playlist){
          this.playlistService.getPlaylistById({jwt_token : token, playlist_id : Number(this.playlist.id)}).then(
            playlist => {if(playlist) this.playlist = playlist}
          )

        }
        }
        
      });
    }
    
  }


  deleteDialog(){
    const deleteDialog = this.dialog.open(DeletePlaylistComponent,{
      minWidth: '300px',
  })
  deleteDialog.afterClosed().subscribe(res=>{
    if(res=='confirm'){
      const token = localStorage.getItem(LOCALSTORAGE_TOKEN_KEY)
        if(this.playlist&&token){
          this.playlistService.deletePlaylist({jwt_token : token, playlist_id : Number(this.playlist!.id)}).then(()=>{
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

  disconnect() { }

  setData(data: Track[]) {
    this._dataStream.next(data);
  }
}