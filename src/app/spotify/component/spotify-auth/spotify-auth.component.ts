import { Component, OnInit } from '@angular/core';
import { MatIconRegistry } from '@angular/material/icon';
import { DomSanitizer } from '@angular/platform-browser';
import { API_URL } from 'src/app/constants';

const spotifyLogoURL = 
"https://upload.wikimedia.org/wikipedia/commons/1/19/Spotify_logo_without_text.svg";

@Component({
  selector: 'app-spotify-auth',
  templateUrl: './spotify-auth.component.html',
  styleUrls: ['./spotify-auth.component.scss']
})


export class SpotifyAuthComponent implements OnInit {

  api_url_login_spotify = API_URL+"auth/spotify/login";


  constructor(private matIconRegistry: MatIconRegistry,
    private domSanitizer: DomSanitizer,) { 
    this.matIconRegistry.addSvgIcon(
      "spotify-logo",
      this.domSanitizer.bypassSecurityTrustResourceUrl(spotifyLogoURL));
   }

  ngOnInit(): void {
  }

}
