import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { HttpClientModule } from '@angular/common/http';
import { JwtModule } from '@auth0/angular-jwt';
import { AuthenticationModule } from './authentication/authentication.module';
import { TagsModule } from './tags/tags.module';
import { NavbarComponent } from './navbar/navbar.component';
import { PlaylistModule } from './playlist/playlist.module';
import { ProfileModule } from './profile/profile.module';
import { HashLocationStrategy, LocationStrategy, registerLocaleData } from '@angular/common';
import localeFr from '@angular/common/locales/fr'
import localeFrExtra from '@angular/common/locales/extra/fr'
import { SharedModule } from './shared/shared.module';
import { CoreModule } from './core/core.module';
// specify the key where the token is stored in the local storage
export const LOCALSTORAGE_TOKEN_KEY = 'local_musictagger_ui';
registerLocaleData(localeFr, 'fr-FR', localeFrExtra)

// specify tokenGetter for the angular jwt package
export function tokenGetter() {
  return localStorage.getItem(LOCALSTORAGE_TOKEN_KEY);
}

@NgModule({
  declarations: [
    AppComponent,
    NavbarComponent,

  ],
  exports: [AppComponent],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    AppRoutingModule,
    SharedModule,
    HttpClientModule,
    AuthenticationModule,
    TagsModule,
    PlaylistModule,
    ProfileModule,
    CoreModule,
    JwtModule.forRoot({
      config: {
        tokenGetter: tokenGetter,
        allowedDomains: ['localhost:3000', 'musictagger.clementpoueyto.fr']
      }
    })
  ],
  providers: [
    { provide: LocationStrategy, useClass: HashLocationStrategy },
   
  ],
  bootstrap: [AppComponent],
  schemas: []
})
export class AppModule { }
