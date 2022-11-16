import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AuthGuard } from '../core/guards/auth-guard/auth.guard';
import { SpotifyFailureComponent } from './component/spotify-failure/spotify-failure.component';
import { SpotifySuccessComponent } from './component/spotify-success/spotify-success.component';

const routes: Routes = [
  { path: 'success', component: SpotifySuccessComponent, canActivate: [AuthGuard] },
  { path: 'failure', component: SpotifyFailureComponent, canActivate: [AuthGuard] }

];


@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class SpotifyRoutingModule { }