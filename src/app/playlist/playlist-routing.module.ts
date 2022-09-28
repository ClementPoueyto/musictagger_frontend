import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AuthGuard } from '../auth-guard/auth.guard';
import { PlaylistComponent } from './components/playlist/playlist.component';
import { PlaylistsManagementComponent } from './components/playlists-management/playlists-management.component';

const routes: Routes = [
  { path : '', component : PlaylistsManagementComponent, canActivate : [AuthGuard]},
  { path : ':id', component : PlaylistComponent, canActivate : [AuthGuard]},

];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class PlaylistRoutingModule { }
