import { DataSource } from '@angular/cdk/collections';
import { Component, HostListener, OnDestroy, OnInit } from '@angular/core';
import { Playlist } from '../../models/playlist.model';
import { ReplaySubject, Observable, Subscription } from 'rxjs'
import { PlaylistService } from '../../services/playlist.service';
import { LOCALSTORAGE_TOKEN_KEY } from 'src/app/app.module';
import { UserService } from 'src/app/tags/services/user.service';
import { MatDialog } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { EditPlaylistComponent } from '../edit-playlist/edit-playlist.component';
@Component({
  selector: 'app-playlists-management',
  templateUrl: './playlists-management.component.html',
  styleUrls: ['./playlists-management.component.scss']
})
export class PlaylistsManagementComponent implements OnInit, OnDestroy {

  displayedColumns: string[] = ['photo', 'title' , 'description', 'tags'];
  dataToDisplay = [];

  nbTagsToDisplay = 50;

  dataSource = new PlaylistDataSource(this.dataToDisplay);

  userSub: Subscription = new Subscription();
  playlistsSub: Subscription = new Subscription();

  constructor(private readonly playlistService: PlaylistService
    , private readonly userService: UserService , 
    public dialog : MatDialog,
    private router : Router) { }

  ngOnDestroy(): void {
    this.playlistsSub.unsubscribe();
  }

  ngOnInit(): void {
    this.userSub = this.userService.currentUser.subscribe(
      user => {
        if(user&&user.spotifyUser){
          this.getData();
        }
      }
    )

  }

  onClickRow(row: Playlist) {
    this.router.navigate(['playlists/'+row.id]);

  }

  openAddPlaylistDialog(){
    const addDialog = this.dialog.open(EditPlaylistComponent, {
      minWidth: '300px',
      disableClose : true,
      data : {
        mode : 'create'
      }
      });
      addDialog.afterClosed().subscribe(result => {
      if(result&&result=='refresh'){
        this.getData();
      }
      
    });
  }

  getData(){
    const token = localStorage.getItem(LOCALSTORAGE_TOKEN_KEY);
    if (token) {
      this.playlistService.getPlaylists({ jwt_token: token }).then(res=>{
        this.dataSource.setData(res)
      }
      );
    }
  }

  @HostListener('window:resize', ['$event'])
  onWindowResize() {
    
    this.onWindowSizeChanging(window.innerWidth,
      window.innerHeight);
  }

  onWindowSizeChanging(width : number, height : number){
    if(width>=700){
      this.nbTagsToDisplay = 20;
      this.displayedColumns = ['photo', 'title', 'description','tags'];
    }
    if(width>=1000){
      this.nbTagsToDisplay = 50;
      this.displayedColumns = ['photo', 'title', 'description','tags'];
    }
    if(width<700){
      this.displayedColumns = ['photo', 'title', 'description','tags'];
      this.nbTagsToDisplay = 10;
    }
    if(width<500){
      this.displayedColumns = ['photo', 'title', 'tags'];
      this.nbTagsToDisplay = 5;
    }
  
  }

}

class PlaylistDataSource extends DataSource<Playlist> {
  private _dataStream = new ReplaySubject<Playlist[]>();

  constructor(initialData: Playlist[]) {
    super();
    this.setData(initialData);
  }

  connect(): Observable<Playlist[]> {
    return this._dataStream;
  }

  disconnect() { }

  setData(data: Playlist[]) {
    this._dataStream.next(data);
  }
}
