import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SpotifyAuthComponent } from './component/spotify-auth/spotify-auth.component';
import { AngularMaterialModule } from '../angular-material/angular-material.module';
import { SpotifySuccessComponent } from './component/spotify-success/spotify-success.component';
import { SpotifyFailureComponent } from './component/spotify-failure/spotify-failure.component';
import { SpotifyRoutingModule } from './spotify-routing.module';



@NgModule({
  declarations: [
    SpotifyAuthComponent,
    SpotifySuccessComponent,
    SpotifyFailureComponent
  ],
  imports: [
    CommonModule,
    SpotifyRoutingModule,
    AngularMaterialModule,
   

  ]
})
export class SpotifyModule { }
