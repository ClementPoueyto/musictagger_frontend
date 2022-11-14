import { HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { firstValueFrom} from 'rxjs';
import { CommonAuthService } from 'src/app/core/services/rest/common-auth.service';
import { Playlist } from '../models/playlist.model';
import { AddPlaylistBodyRequest, AddPlaylistsRequest, DeletePlaylistsRequest, GetPlaylistByIdRequest, GetPlaylistsRequest, GetPlaylistTracksByIdRequest, GetPlaylistTracksByIdResponse, UpdatePlaylistsRequest } from './playlist.interface';


@Injectable({
  providedIn: 'root'
})
export class PlaylistService extends CommonAuthService {


  async getPlaylists(playlistRequest: GetPlaylistsRequest): Promise<Playlist[]> {
    const request = await this.authService.checkToken({ jwt_token: playlistRequest.jwt_token })
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.get<Playlist[]>(this.apiConfiguration.api_url + 'playlists?userId=' + request.decoded.userId,
     
      { headers: headers })
    );
    return res;
  }

  async getPlaylistById(playlistRequest: GetPlaylistByIdRequest): Promise<Playlist> {
    const request = await this.authService.checkToken({ jwt_token: playlistRequest.jwt_token })
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.get<Playlist>(this.apiConfiguration.api_url + 'playlists/'+playlistRequest.playlist_id+'?userId=' + request.decoded.userId,
     
      { headers: headers })

    );
    return res;
  }

  async getPlaylistTracksById(playlistRequest: GetPlaylistTracksByIdRequest): Promise<GetPlaylistTracksByIdResponse> {
    const request = await this.authService.checkToken({ jwt_token: playlistRequest.jwt_token })
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.get<GetPlaylistTracksByIdResponse>(this.apiConfiguration.api_url + 'playlists/'+playlistRequest.playlist_id+'/tracks?userId=' + request.decoded.userId
    +"&size="+playlistRequest.limit+"&page="+playlistRequest.page,
     
      { headers: headers })

    );
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
    const res = await firstValueFrom(this.http.post<Playlist>(this.apiConfiguration.api_url + 'playlists?userId=' + request.decoded.userId,
     body,
      { headers: headers })

    );
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
    const res = await firstValueFrom(this.http.put<Playlist>(this.apiConfiguration.api_url + 'playlists/'+playlistFormRequest.playlist_id+'?userId=' + request.decoded.userId,
     body,
      { headers: headers })
    );
    return res;
  }

  async deletePlaylist(deletePlaylistRequest: DeletePlaylistsRequest) {
    const request = await this.authService.checkToken({ jwt_token: deletePlaylistRequest.jwt_token })
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })

    const res = await firstValueFrom(this.http.delete(this.apiConfiguration.api_url + 'playlists/'+deletePlaylistRequest.playlist_id+'?userId=' + request.decoded.userId,
      { headers: headers })

    );
  }

 
}
