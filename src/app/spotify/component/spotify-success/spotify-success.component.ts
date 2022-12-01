import { Component, OnInit, OnDestroy } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { ActivatedRoute, Router } from '@angular/router';
import { LOCALSTORAGE_TOKEN_KEY } from 'src/app/app.module';
import { SpotifyUser } from 'src/app/shared/models/spotify-user.model';
import { Subscription } from 'rxjs';
import { UserService } from 'src/app/shared/services/user.service';
@Component({
  selector: 'app-spotify-success',
  templateUrl: './spotify-success.component.html',
  styleUrls: ['./spotify-success.component.scss'],
})
export class SpotifySuccessComponent implements OnInit, OnDestroy {
  routeSub: Subscription = new Subscription();
  constructor(
    private readonly userService: UserService,
    private router: Router,
    private snackbar: MatSnackBar,
    private route: ActivatedRoute
  ) {}
  ngOnDestroy(): void {
    this.routeSub.unsubscribe();
  }

  ngOnInit(): void {
    this.routeSub = this.route.queryParams.subscribe(async (params) => {
      const spotifyUser: SpotifyUser = {
        spotifyId: params['spotifyId'],
        spotifyAccessToken: params['spotifyAccessToken'],
        spotifyRefreshToken: params['spotifyRefreshToken'],
        expiresIn: params['expiresIn'],
      };
      const new_token = await this.userService.logInSpotifyUser({
        spotifyUser: spotifyUser,
      });
      await localStorage.setItem(LOCALSTORAGE_TOKEN_KEY, new_token.jwt_token);
      if (new_token) {
        this.snackbar.open('Spotify Login Success', 'Close', {
          duration: 2000,
          horizontalPosition: 'right',
          verticalPosition: 'top',
        });
        this.userService.getUser().then((res) => {
          if (res) {
            this.router.navigate(['/']);
          }
        });
      }
    });
  }
}
