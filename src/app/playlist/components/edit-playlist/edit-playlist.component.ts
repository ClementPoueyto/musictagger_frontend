import { Component, Inject, OnInit } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { TagService } from 'src/app/tags/services/tag.service';
import { PlaylistService } from '../../services/playlist.service';

@Component({
  selector: 'app-edit-playlist',
  templateUrl: './edit-playlist.component.html',
  styleUrls: ['./edit-playlist.component.scss']
})
export class EditPlaylistComponent implements OnInit {

  playlistForm = new FormGroup({
    title: new FormControl("", [Validators.required]),
    description: new FormControl(""),

  },
  )
  tagNames: string[] = [];
  selected: string[] = [];
  playlistId: number | null = null;
  mode: 'edit' | 'create' = 'create';

  availableTracks   = 0;

  constructor(
    public dialogRef: MatDialogRef<EditPlaylistComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    private readonly tagService: TagService, private readonly playlistService: PlaylistService) {
    this.mode = this.data.mode

    if (this.mode === 'edit') {
      this.selected = [...this.data.selected];
      this.playlistId = this.data.id;
      this.playlistForm.setValue({
        title: this.data.title,
        description: this.data.description
      })
    }
    

  }

  ngOnInit(): void {
      this.tagService.getTagNames().then(tags => {
        this.tagNames = tags.tagNames;
      });
    this.updateAvailableTracks();

  }

  editPlaylist() {
    if (this.playlistForm.get('title')?.value && this.selected.length > 0) {
      if (this.mode == 'create') {
        this.playlistService.addPlaylist({
          name: this.playlistForm.get('title')?.value as string,
          description: this.playlistForm.get('description')?.value as string,
          tags: this.selected
        }).then(res => {
          this.dialogRef.close('refresh')
        })
      }
      if (this.mode == 'edit') {
        this.playlistService.updatePlaylist({
          playlist_id: this.playlistId as number,
          name: this.playlistForm.get('title')?.value as string,
          description: this.playlistForm.get('description')?.value as string,
          tags: this.selected
        }).then(() => {
          this.dialogRef.close('refresh')
        })
      }
    }

  }

  updateAvailableTracks(){
      this.tagService.searchTaggedTrack({ page : 0, limit : 0, tags : this.selected, query : "", onlyMetadata : true}).then(
        res=>{
          if(res && res.metadata.total){
            this.availableTracks = res.metadata.total
          }
        }
      )
    
  }


  onChipDialogChange(tag: string) {
    if (this.selected.includes(tag)) {
      this.selected = this.selected.filter(val => val != tag);
    }
    else {
      this.selected.push(tag)
    }
    this.updateAvailableTracks()

  }

  close() {
    this.dialogRef.close()
  }

}

