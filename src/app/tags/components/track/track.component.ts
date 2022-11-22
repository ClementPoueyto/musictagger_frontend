import { Component, OnInit, OnDestroy } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { ActivatedRoute, Router } from '@angular/router';
import { Subscription } from 'rxjs';
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


  constructor(private router : Router,private readonly route : ActivatedRoute, private readonly tagService : TagService,
    private snackbar: MatSnackBar,) { 
    }

  tagtrack : TaggedTrack | null = null;


  
  tagNames : string[] = []

  ngOnInit(): void {
    this.routeSub = this.route.url
    .subscribe(async url => { 
      const id : number = Number(url[1].path)
      if(id){
           this.tagtrack = await this.tagService.getTaggedTrackByTrackId( {trackId : id})
        
      }
      else{
        this.snackbar.open('get TaggedTrack fail', 'Close', {
          duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
        });      
      }
      
    });
      this.tagService.getTagNames().then(tags=>{
        this.tagNames = tags.tagNames;
      });
    

  }

  goBack(){
    this.router.navigate(["/tags"])
  }

  ngOnDestroy(): void {
    this.routeSub.unsubscribe();
  }

  onChipChange(value : any){
    if(this.tagtrack?.track){
      if(!this.tagtrack?.tags.includes(value)){
        this.tagService.addTag({ body:  {tag : value, trackId : this.tagtrack.track.id}})
      }
      else{
        this.tagService.deleteTag({ body:  {tag : value, trackId : this.tagtrack.track.id}})
      }
    }
  }

  addTag(){
    const input = this.value.trim();
    if(input==""){
      this.snackbar.open('empty tag', 'Close', {
        duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
      });  
      return;
    }
    if(input!=""&&!this.tagtrack?.tags.includes(input)){
      if(this.tagtrack?.track){
        if(!this.tagNames.includes(input)){
          this.onChipChange(input)
          this.tagNames.push(input);
          this.tagtrack.tags.push(input);
        }
        this.value = ''
    }
  }
else{
  this.snackbar.open('tag already selected', 'Close', {
    duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
  });  
}}

}
