import { DataSource } from '@angular/cdk/collections';
import { Component, HostListener, OnDestroy, OnInit } from '@angular/core';
import { Playlist } from '../../models/playlist.model';
import { ReplaySubject, Observable, Subscription } from 'rxjs'
import { PlaylistService } from '../../services/playlist.service';
import { MatDialog } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { EditPlaylistComponent } from '../edit-playlist/edit-playlist.component';
import { UserService } from 'src/app/shared/services/user.service';
@Component({
  selector: 'app-playlists-management',
  templateUrl: './playlists-management.component.html',
  styleUrls: ['./playlists-management.component.scss']
})
export class PlaylistsManagementComponent implements OnInit, OnDestroy {

  displayedColumns: string[] = ['title' , 'description', 'tags'];
  dataToDisplay = [];

  nbTagsToDisplay = 50;
  nbElements = 0;
  dataSource = new PlaylistDataSource(this.dataToDisplay);
  
  userSub: Subscription = new Subscription();
  playlistsSub: Subscription = new Subscription();

  displayLoader  = true;

  constructor(private readonly playlistService: PlaylistService
    , private readonly userService: UserService, 
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
    this.router.navigate(['/playlists/'+row.id]);

  }

  openAddPlaylistDialog(){
    const addDialog = this.dialog.open(EditPlaylistComponent, {
      minWidth: '95%',
      disableClose : true,
      height : '95%'
,      data : {
        mode : 'create'
      }
      });
      addDialog.afterOpened().subscribe(()=>{
        this.displayLoader = false;
      })
      addDialog.afterClosed().subscribe(result => {
      if(result&&result=='refresh'){
        this.displayLoader = true;
        this.getData();
      }
      
    });
  }

  getData(){
      this.playlistService.getPlaylists().then(res=>{
        this.dataSource.setData(res)
        this.nbElements = res.length
      }
      );
  }

  @HostListener('window:resize', ['$event'])
  onWindowResize() {
    
    this.onWindowSizeChanging(window.innerWidth);
  }

  onWindowSizeChanging(width : number){
    if(width>=700){
      this.displayedColumns = ['title' , 'description', 'tags'];
      this.nbTagsToDisplay = 20;
    }
    if(width>=1000){
      this.displayedColumns = ['title' , 'description', 'tags'];
      this.nbTagsToDisplay = 50;
    }
    if(width<700){
      this.displayedColumns = ['title' , 'description', 'tags'];
      this.nbTagsToDisplay = 10;
    }
    if(width<500){
      this.displayedColumns = ['title' , 'tags'];
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

  disconnect() { this._dataStream.complete(); }

  setData(data: Playlist[]) {
    this._dataStream.next(data);
  }
}
