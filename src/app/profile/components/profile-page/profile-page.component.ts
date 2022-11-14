import { Component, Inject, OnInit } from '@angular/core';
import { LOCALSTORAGE_TOKEN_KEY } from 'src/app/app.module';
import { User } from 'src/app/tags/models/user.model';
import { UserService } from 'src/app/tags/services/user.service';
import { Subscription} from 'rxjs'
import { DomSanitizer } from '@angular/platform-browser';
import { MatIconRegistry } from '@angular/material/icon';
import { AuthService } from 'src/app/authentication/services/auth.service';
import { Router } from '@angular/router';
import { environment } from 'src/environments/environment';
const spotifyLogoURL = 
"https://upload.wikimedia.org/wikipedia/commons/1/19/Spotify_logo_without_text.svg";

@Component({
  selector: 'app-profile-page',
  templateUrl: './profile-page.component.html',
  styleUrls: ['./profile-page.component.scss']
})
export class ProfilePageComponent implements OnInit {
  api_url_login_spotify = environment.API_URL+"auth/spotify/login";
  constructor(private router: Router,private readonly userService : UserService, private readonly authService : AuthService, private matIconRegistry: MatIconRegistry,
    private domSanitizer: DomSanitizer,) { 
    this.matIconRegistry.addSvgIcon(
      "spotify-logo",
      this.domSanitizer.bypassSecurityTrustResourceUrl(spotifyLogoURL)) }

  profile : User | null = null;
  userSub : Subscription= new Subscription();
  ngOnInit(): void {
    this.userSub = this.userService.currentUser.subscribe(user=>{
      if(user){
        this.profile = user;
      }
    })

    
  }

  logoutSpotify(){
    const token = localStorage.getItem(LOCALSTORAGE_TOKEN_KEY)
    if(token){
      this.userService.logoutSpotifyUser({jwt_token : token}).then(res=>{
        if(res){
          this.userService.getUser({jwt_token : res.jwt_token}).then(profile=>{
            if(profile){
              this.router.navigate(["../"])
            }
          })
        }
      })
    }
  }


  logout(){
    this.userService.logout();
    this.authService.logout();
  }

  login(){
    this.router.navigate(["../"])
  }


}
