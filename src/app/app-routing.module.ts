import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AuthenticationRoutingModule } from './authentication/authentication-routing.module';
import { SpotifyRoutingModule } from './spotify/spotify-routing.module';
import { TagsRoutingModule } from './tags/tags-routing.module';

const routes: Routes = [

  {
    path: 'tags',
    loadChildren: () => TagsRoutingModule,
  },
  {
    path: 'spotify',
    loadChildren: () => SpotifyRoutingModule,
  },
  {
    path: '',
    loadChildren: () => AuthenticationRoutingModule,
  },
  { path: '', redirectTo: 'auth', pathMatch: 'full' },
  {
    path: '**',
    redirectTo: 'login',
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
