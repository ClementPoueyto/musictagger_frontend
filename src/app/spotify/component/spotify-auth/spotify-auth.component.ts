import { Component } from '@angular/core';
import { MatIconRegistry } from '@angular/material/icon';
import { DomSanitizer } from '@angular/platform-browser';
import { apiUrlLoginSpotify, spotifyLogoURL } from 'src/app/constants';


@Component({
  selector: 'app-spotify-auth',
  templateUrl: './spotify-auth.component.html',
  styleUrls: ['./spotify-auth.component.scss']
})


export class SpotifyAuthComponent{

  api_url_login_spotify = apiUrlLoginSpotify;


  constructor(private matIconRegistry: MatIconRegistry,
    private domSanitizer: DomSanitizer,) { 
    this.matIconRegistry.addSvgIcon(
      "spotify-logo",
      this.domSanitizer.bypassSecurityTrustResourceUrl(spotifyLogoURL));
   }

}
