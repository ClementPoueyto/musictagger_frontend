import { Component } from '@angular/core';
import { MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'app-delete-playlist',
  templateUrl: './delete-playlist.component.html',
  styleUrls: ['./delete-playlist.component.scss']
})
export class DeletePlaylistComponent{

  constructor(public dialogRef: MatDialogRef<DeletePlaylistComponent>,) { }

  cancel(){
    this.dialogRef.close();
  }

  delete(){
    this.dialogRef.close('confirm')
  }

}
