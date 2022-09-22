import { Component, OnInit } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { Router } from '@angular/router';

@Component({
  selector: 'app-spotify-failure',
  templateUrl: './spotify-failure.component.html',
  styleUrls: ['./spotify-failure.component.scss']
})
export class SpotifyFailureComponent implements OnInit {

  constructor( private router: Router,
    private snackbar: MatSnackBar) { }

  ngOnInit(): void {
    this.snackbar.open('Spotify Login Failure', 'Close', {
      duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
    });
    this.router.navigate(['../tags']);
   
  }

}
