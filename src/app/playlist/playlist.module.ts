import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PlaylistRoutingModule } from './playlist-routing.module';
import { HttpClientModule } from '@angular/common/http';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { BrowserModule } from '@angular/platform-browser';
import { PlaylistsManagementComponent } from './components/playlists-management/playlists-management.component';
import { TagsModule } from '../tags/tags.module';
import { MatDialogModule } from '@angular/material/dialog';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { PlaylistComponent } from './components/playlist/playlist.component';
import { EditPlaylistComponent } from './components/edit-playlist/edit-playlist.component';
import { DeletePlaylistComponent } from './components/delete-playlist/delete-playlist.component';
import { SharedModule } from '../shared/shared.module';


@NgModule({
  declarations: [
    PlaylistsManagementComponent,
    PlaylistComponent,
    EditPlaylistComponent,
    DeletePlaylistComponent
  ],
  imports: [
    CommonModule,
    PlaylistRoutingModule,
    BrowserModule,
    BrowserAnimationsModule,
    CommonModule,
    HttpClientModule,
    TagsModule,
    MatDialogModule,
    ReactiveFormsModule,
    FormsModule,
    MatDialogModule,
    SharedModule
  ],
  providers: [

  ],
})
export class PlaylistModule { }
