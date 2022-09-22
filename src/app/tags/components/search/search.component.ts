import { Component, OnInit } from '@angular/core';
import { LOCALSTORAGE_TOKEN_KEY } from 'src/app/app.module';
import { Router } from '@angular/router';
import { DataSource } from '@angular/cdk/collections';
import { TaggedTrack } from '../../models/tagged-track.model';
import {Observable, ReplaySubject} from 'rxjs';
import { TagService } from '../../services/tag.service';
import { UserService } from '../../services/user.service';

@Component({
  selector: 'app-search',
  templateUrl: './search.component.html',
  styleUrls: ['./search.component.scss']
})
export class SearchComponent implements OnInit {

  displayedColumns: string[] = ['photo', 'title', 'album', 'tags'];
  dataToDisplay = [];

  dataSource = new TrackDataSource(this.dataToDisplay);

  constructor(private tagService : TagService,private userService : UserService

    ) { }

  ngOnInit(): void {
    const token = localStorage.getItem(LOCALSTORAGE_TOKEN_KEY);
    if(token){
      this.userService.user$.subscribe(
        user=>{
          if(user&&user.spotifyUser){
            this.tagService.searchTaggedTrack({jwt_token : token, page : 0, tags : [], query : "" }).then(
              res=> {
                this.dataSource.setData(res.data)
              }
            );
          }
        }
      )
      
    }
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
