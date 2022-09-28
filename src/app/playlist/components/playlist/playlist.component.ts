import { Component, Input, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { LOCALSTORAGE_TOKEN_KEY } from 'src/app/app.module';
import { User } from 'src/app/tags/models/user.model';
import { Playlist } from '../../models/playlist.model';
import { PlaylistService } from '../../services/playlist.service';
import { Subscription } from 'rxjs'
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { Dialog } from '@angular/cdk/dialog';
import { EditPlaylistComponent } from '../edit-playlist/edit-playlist.component';
import { MatDialog } from '@angular/material/dialog';
import { DeletePlaylistComponent } from '../delete-playlist/delete-playlist.component';

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

  constructor(private playlistService : PlaylistService, private route : ActivatedRoute, private router : Router,private dialog : MatDialog) { 
    this.routeSub = this.route.url.subscribe(url=>{
      const id : number = Number(url[0].path)
      if(id){
        const token = localStorage.getItem(LOCALSTORAGE_TOKEN_KEY)
        if(token){
          this.playlistService.getPlaylistById({jwt_token : token, playlist_id : id}).then(
            playlist => {if(playlist) this.playlist = playlist}
          )

        }
      }
    })
    
  }

  ngOnInit(): void {
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
       editDialog.afterClosed().subscribe(result => {
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
            this.router.navigate(["../playlists"])
          })
        }
    }
  })
}


}
