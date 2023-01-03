import { Component, Input } from '@angular/core';
import { MatIconRegistry } from '@angular/material/icon';
import { DomSanitizer } from '@angular/platform-browser';
import { spotifyLogoURL } from 'src/app/constants';

@Component({
  selector: 'app-spotify-redirection-buttton',
  templateUrl: './spotify-redirection-buttton.component.html',
  styleUrls: ['./spotify-redirection-buttton.component.scss'],
})
export class SpotifyRedirectionButttonComponent {
  @Input()
  spotifyLink = '';
  constructor(
    private matIconRegistry: MatIconRegistry,
    private domSanitizer: DomSanitizer
  ) {
    this.matIconRegistry.addSvgIcon(
      'spotify-logo',
      this.domSanitizer.bypassSecurityTrustResourceUrl(spotifyLogoURL)
    );
  }

  goTo() {
    window.open(this.spotifyLink, '_blank');
  }
}
