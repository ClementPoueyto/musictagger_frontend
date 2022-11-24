import { Component, OnDestroy, OnInit } from '@angular/core';
import { User } from 'src/app/shared/models/user.model';
import { Subscription } from 'rxjs'
import { DomSanitizer } from '@angular/platform-browser';
import { MatIconRegistry } from '@angular/material/icon';
import { AuthService } from 'src/app/authentication/services/auth.service';
import { Router } from '@angular/router';
import { UserService } from 'src/app/shared/services/user.service';
import { apiUrlLoginSpotify, spotifyLogoURL } from 'src/app/constants';


@Component({
  selector: 'app-profile-page',
  templateUrl: './profile-page.component.html',
  styleUrls: ['./profile-page.component.scss']
})
export class ProfilePageComponent implements OnInit, OnDestroy {
  api_url_login_spotify = apiUrlLoginSpotify;
  constructor(private router: Router, private readonly userService: UserService, private readonly authService: AuthService, private matIconRegistry: MatIconRegistry,
    private domSanitizer: DomSanitizer,) {
    this.matIconRegistry.addSvgIcon(
      "spotify-logo",
      this.domSanitizer.bypassSecurityTrustResourceUrl(spotifyLogoURL))
  }

  profile: User | null = null;
  userSub: Subscription = new Subscription();
  ngOnInit(): void {
    this.userSub = this.userService.currentUser.subscribe(user => {
      if (user) {
        this.profile = user;
      }
    })


  }

  logoutSpotify() {

    this.userService.logoutSpotifyUser().then(res => {
      if (res) {
        this.userService.getUser().then(profile => {
          if (profile) {
            this.router.navigate(["../"])
          }
        })
      }
    })

  }


  logout() {
    this.userService.logout();
    this.authService.logout();
  }

  login() {
    this.router.navigate(["../"])
  }

  ngOnDestroy(): void {
    this.userSub.unsubscribe();
  }


}
