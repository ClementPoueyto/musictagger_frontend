import { Component, OnInit } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { ActivatedRoute, Router } from '@angular/router';
import { LOCALSTORAGE_TOKEN_KEY } from 'src/app/app.module';
import { SpotifyUser } from 'src/app/tags/models/spotify-user.model';
import { UserService } from 'src/app/tags/services/user.service';

@Component({
  selector: 'app-spotify-success',
  templateUrl: './spotify-success.component.html',
  styleUrls: ['./spotify-success.component.scss']
})
export class SpotifySuccessComponent implements OnInit {

  constructor(private readonly userService : UserService,      private router: Router,
    private snackbar: MatSnackBar,    private route: ActivatedRoute,

    ) { }

  ngOnInit(): void {
    this.route.queryParams
    .subscribe(async params => { 
      const spotifyUser : SpotifyUser = {
        spotifyId : params["spotifyId"],
        spotifyAccessToken : params["spotifyAccessToken"],
        spotifyRefreshToken : params["spotifyRefreshToken"],
        expiresIn : params["expiresIn"],
      }     
      const token = localStorage.getItem(LOCALSTORAGE_TOKEN_KEY);
      if(token){
        const new_token = await this.userService.logInSpotifyUser({jwt_token : token, spotifyUser: spotifyUser});
        await localStorage.setItem(LOCALSTORAGE_TOKEN_KEY, new_token.jwt_token);
        if(new_token){
          this.snackbar.open('Spotify Login Success', 'Close', {
            duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
          });
          setTimeout(()=>{
            this.router.navigate(['../tags']);
          },2000)

        }
      }
      
      
    } 
  );
  }



}
