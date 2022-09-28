import { Component, OnInit } from '@angular/core';
import { MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'app-delete-playlist',
  templateUrl: './delete-playlist.component.html',
  styleUrls: ['./delete-playlist.component.scss']
})
export class DeletePlaylistComponent implements OnInit {

  constructor(public dialogRef: MatDialogRef<DeletePlaylistComponent>,) { }

  ngOnInit(): void {
  }

  cancel(){
    this.dialogRef.close();
  }

  delete(){
    this.dialogRef.close('confirm')
  }

}
