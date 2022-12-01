import { Dialog } from '@angular/cdk/dialog';
import { Component, OnInit, OnDestroy } from '@angular/core';
import { AuthService, AuthStatus } from './authentication/services/auth.service';
import { SpotifyAuthComponent } from './spotify/component/spotify-auth/spotify-auth.component';
import { Subscription } from 'rxjs';
import { UserService } from './shared/services/user.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements OnInit, OnDestroy {

  userSub: Subscription = new Subscription();
  authSub: Subscription = new Subscription();

  constructor(private readonly userService: UserService, private readonly authService: AuthService, public dialog: Dialog) {

  }



  ngOnInit(): void {
    this.userSub = this.userService.currentUser.subscribe(user => {
      if (user) {
        if (!user.spotifyUser) {
          this.openStreamingAuthDialog();
        }
        else {
          this.dialog.closeAll();
        }
      }
    })
    this.authSub = this.authService.currentAuthStatus.subscribe(status => {
      if (status === AuthStatus.LOGIN) {
        this.userService.updateUserId();
        this.userService.getUser();
      }
    })
  }

  openStreamingAuthDialog() {
    this.dialog.open(SpotifyAuthComponent, {
      disableClose: true,
      minWidth: '300px',

    });
  }

  ngOnDestroy(): void {
    this.userSub.unsubscribe();
    this.authSub.unsubscribe();

  }
}
