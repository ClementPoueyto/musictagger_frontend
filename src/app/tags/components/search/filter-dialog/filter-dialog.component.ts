import { Component, Inject, OnInit, Optional } from '@angular/core';
import { LOCALSTORAGE_TOKEN_KEY } from 'src/app/app.module';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { TagService } from 'src/app/tags/services/tag.service';

@Component({
  selector: 'app-filter-dialog',
  templateUrl: './filter-dialog.component.html',
  styleUrls: ['./filter-dialog.component.scss']
})
export class FilterDialogComponent  {

  tagNames : string[] = [];
  selected : string[] = [];
  constructor(
   
    public dialogRef: MatDialogRef<FilterDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    private readonly tagService : TagService,

  ) { 
    this.selected = [...this.data.selected]

  }


  ngOnInit(): void {
   
    const token = localStorage.getItem(LOCALSTORAGE_TOKEN_KEY);
    if(token){
      this.tagService.getTagNames({jwt_token :token }).then(tags=>{
        this.tagNames = tags.tagNames;
      });
    }
  }

  onChipDialogChange(value : any){
    if(value.trim()!=""){
    if(!this.selected.includes(value)){
      this.selected.push(value)
    }
    else{
      this.selected = this.selected.filter(val => val!=value)
    }    
  }
  }

  onResetClick(){
    this.selected = [];
  }

  onSaveClick(){
   this.dialogRef.close(this.selected);

  }

}
