import { Component, OnInit, OnDestroy } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { MatSnackBar } from '@angular/material/snack-bar';
import { ActivatedRoute } from '@angular/router';
import { Subscription, firstValueFrom } from 'rxjs';
import { LOCALSTORAGE_TOKEN_KEY } from 'src/app/app.module';
import { TaggedTrack } from '../../models/tagged-track.model';
import { TagService } from '../../services/tag.service';

@Component({
  selector: 'app-track',
  templateUrl: './track.component.html',
  styleUrls: ['./track.component.scss']
})
export class TrackComponent implements OnInit, OnDestroy {

  routeSub : Subscription = new Subscription();

  value = '';


  constructor(private readonly route : ActivatedRoute, private readonly tagService : TagService,
    private snackbar: MatSnackBar,) { 
    }

  tagtrack : TaggedTrack | null = null;


  tagNames : string[] = []

  ngOnInit(): void {
    this.routeSub = this.route.url
    .subscribe(async url => { 
      const id : number = Number(url[1].path)
      if(id){
        const token = localStorage.getItem(LOCALSTORAGE_TOKEN_KEY);
        if(token){
           this.tagtrack = await this.tagService.getTaggedTrackByTrackId({jwt_token : token, trackId : id})
        }
      }
      else{
        this.snackbar.open('get TaggedTrack fail', 'Close', {
          duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
        });      
      }
      
    });
    const token = localStorage.getItem(LOCALSTORAGE_TOKEN_KEY);
    if(token){
      this.tagService.getTagNames({jwt_token :token }).then(tags=>{
        this.tagNames = tags.tagNames;
      });
    }
  }


  ngOnDestroy(): void {
    this.routeSub.unsubscribe();
  }

  onChipChange($event : any, value : any){
    const token = localStorage.getItem(LOCALSTORAGE_TOKEN_KEY);
    if(token&&this.tagtrack?.track){
      if($event.selected){
        this.tagService.addTag({jwt_token : token, body:  {tag : value, trackId : this.tagtrack.track.id}})
      }
      else{
        this.tagService.deleteTag({jwt_token : token, body:  {tag : value, trackId : this.tagtrack.track.id}})
      }
    }
  }

  addTag(){
    const input = this.value.trim();
    if(input!=""&&!this.tagtrack?.tags.includes(input)){
      const token = localStorage.getItem(LOCALSTORAGE_TOKEN_KEY);
      if(token&&this.tagtrack?.track){
        if(!this.tagNames.includes(input)){
          this.tagNames.push(input);
          this.tagtrack.tags.push(input)
        }

          this.tagService.addTag({jwt_token : token, body:  {tag : input, trackId : this.tagtrack.track.id}}).then(res=>{
            this.tagtrack = res;
          })
        this.value = ''
    }
  }
else{
  this.snackbar.open('tag already selected', 'Close', {
    duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
  });  
}}

}
