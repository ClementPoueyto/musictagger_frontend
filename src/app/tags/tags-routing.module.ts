import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AuthGuard } from '../auth-guard/auth.guard';
import { HomeComponent } from './components/home/home.component';
import { TrackComponent } from './components/track/track.component';

const routes: Routes = [
  { path : '', component : HomeComponent, canActivate : [AuthGuard]},

  { path : 'tracks/:id', component : TrackComponent, canActivate : [AuthGuard]}

];


@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class TagsRoutingModule { }
