import { HttpClient, HttpHeaders } from '@angular/common/http';
import { EventEmitter, Injectable } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { catchError, firstValueFrom, Observable, of } from 'rxjs';
import { AuthService } from 'src/app/authentication/services/auth.service';
import { API_URL } from 'src/app/constants';
import { Playlist } from '../models/playlist.model';
import { AddPlaylistBodyRequest, AddPlaylistsRequest, DeletePlaylistsRequest, GetPlaylistByIdRequest, GetPlaylistsRequest, GetPlaylistTracksByIdRequest, GetPlaylistTracksByIdResponse, UpdatePlaylistsRequest } from './playlist.interface';


@Injectable({
  providedIn: 'root'
})
export class PlaylistService {

  constructor(private readonly authService: AuthService, private http: HttpClient,
    private snackbar: MatSnackBar,) { }

  async getPlaylists(playlistRequest: GetPlaylistsRequest): Promise<Playlist[]> {
    const request = await this.authService.checkToken({ jwt_token: playlistRequest.jwt_token })
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.get<Playlist[]>(API_URL + 'playlists?userId=' + request.decoded.userId,
     
      { headers: headers }).pipe(
        catchError(() => {
          this.snackbar.open('get playlists fail', 'Close', {
            duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
          });
          return of();
        }),),

    );
    console.log(res)
    return res;
  }

  async getPlaylistById(playlistRequest: GetPlaylistByIdRequest): Promise<Playlist> {
    const request = await this.authService.checkToken({ jwt_token: playlistRequest.jwt_token })
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.get<Playlist>(API_URL + 'playlists/'+playlistRequest.playlist_id+'?userId=' + request.decoded.userId,
     
      { headers: headers }).pipe(
        catchError(() => {
          this.snackbar.open('get playlists fail', 'Close', {
            duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
          });
          return of();
        }),),

    );
    console.log(res)
    return res;
  }

  async getPlaylistTracksById(playlistRequest: GetPlaylistTracksByIdRequest): Promise<GetPlaylistTracksByIdResponse> {
    const request = await this.authService.checkToken({ jwt_token: playlistRequest.jwt_token })
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.get<GetPlaylistTracksByIdResponse>(API_URL + 'playlists/'+playlistRequest.playlist_id+'/tracks?userId=' + request.decoded.userId
    +"&size="+playlistRequest.limit+"&page="+playlistRequest.page,
     
      { headers: headers }).pipe(
        catchError(() => {
          this.snackbar.open('get playlists fail', 'Close', {
            duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
          });
          return of();
        }),),

    );
    console.log(res)
    return res;
  }

  async addPlaylist(playlistFormRequest: AddPlaylistsRequest): Promise<Playlist> {
    const request = await this.authService.checkToken({ jwt_token: playlistFormRequest.jwt_token })
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })

    const body : AddPlaylistBodyRequest = {
        playlist : {
            name : playlistFormRequest.name,
            description : playlistFormRequest.description,
            public : false,
            collaborative : false
        },
        tags : playlistFormRequest.tags
    }
    const res = await firstValueFrom(this.http.post<Playlist>(API_URL + 'playlists?userId=' + request.decoded.userId,
     body,
      { headers: headers }).pipe(
        catchError(() => {
          this.snackbar.open('add playlist fail', 'Close', {
            duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
          });
          return of();
        }),),

    );
    console.log(res)
    return res;
  }

  async updatePlaylist(playlistFormRequest: UpdatePlaylistsRequest): Promise<Playlist> {
    const request = await this.authService.checkToken({ jwt_token: playlistFormRequest.jwt_token })
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })

    const body : AddPlaylistBodyRequest = {
        playlist : {
            name : playlistFormRequest.name,
            description : playlistFormRequest.description,
            public : false,
            collaborative : false
        },
        tags : playlistFormRequest.tags
    }
    const res = await firstValueFrom(this.http.put<Playlist>(API_URL + 'playlists/'+playlistFormRequest.playlist_id+'?userId=' + request.decoded.userId,
     body,
      { headers: headers }).pipe(
        catchError((err) => {
          this.snackbar.open('update playlist fail | '+err.error.message, 'Close', {
            duration: 5000, horizontalPosition: 'right', verticalPosition: 'top'
          });
          return of();
        }),),

    );
    console.log(res)
    return res;
  }

  async deletePlaylist(deletePlaylistRequest: DeletePlaylistsRequest) {
    const request = await this.authService.checkToken({ jwt_token: deletePlaylistRequest.jwt_token })
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })

    const res = await firstValueFrom(this.http.delete(API_URL + 'playlists/'+deletePlaylistRequest.playlist_id+'?userId=' + request.decoded.userId,
      { headers: headers }).pipe(
        catchError((err) => {
          this.snackbar.open('delete playlist fail | '+err.error.message, 'Close', {
            duration: 5000, horizontalPosition: 'right', verticalPosition: 'top'
          });
          return of();
        }),),

    );
    console.log(res)
  }

 
}
