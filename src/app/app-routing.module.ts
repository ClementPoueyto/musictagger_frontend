import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AuthenticationRoutingModule } from './authentication/authentication-routing.module';
import { PlaylistRoutingModule } from './playlist/playlist-routing.module';
import { SpotifyRoutingModule } from './spotify/spotify-routing.module';
import { TagsRoutingModule } from './tags/tags-routing.module';

const routes: Routes = [

  {
    path: '',
    loadChildren: () => TagsRoutingModule,
  },
  {
    path: 'spotify',
    loadChildren: () => SpotifyRoutingModule,
  },
  {
    path: 'export',
    loadChildren: () => PlaylistRoutingModule,
  },
  {
    path: 'auth',
    loadChildren: () => AuthenticationRoutingModule,
  },
  {
    path: '**',
    redirectTo: '',
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes, { scrollPositionRestoration : 'disabled'})],
  exports: [RouterModule]
})
export class AppRoutingModule { }
