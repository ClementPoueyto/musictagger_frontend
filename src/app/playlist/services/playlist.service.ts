import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { firstValueFrom } from 'rxjs';
import { CommonService } from 'src/app/shared/services/rest/common.service';
import { UserService } from 'src/app/shared/services/user.service';
import { Playlist } from '../models/playlist.model';
import {
  AddPlaylistBodyRequest,
  AddPlaylistsRequest,
  DeletePlaylistsRequest,
  GetPlaylistByIdRequest,
  GetPlaylistTracksByIdRequest,
  GetPlaylistTracksByIdResponse,
  UpdatePlaylistsRequest,
} from './playlist.interface';

@Injectable({
  providedIn: 'root',
})
export class PlaylistService extends CommonService {
  constructor(
    protected override http: HttpClient,
    private userService: UserService
  ) {
    super(http);
  }

  async getPlaylists(): Promise<Playlist[]> {
    const res = await firstValueFrom(
      this.http.get<Playlist[]>(
        this.apiConfiguration.api_url +
          'playlists?userId=' +
          this.userService.getUserId()
      )
    );
    return res;
  }

  async getPlaylistById(
    playlistRequest: GetPlaylistByIdRequest
  ): Promise<Playlist> {
    const res = await firstValueFrom(
      this.http.get<Playlist>(
        this.apiConfiguration.api_url +
          'playlists/' +
          playlistRequest.playlist_id +
          '?userId=' +
          this.userService.getUserId()
      )
    );
    return res;
  }

  async getPlaylistTracksById(
    playlistRequest: GetPlaylistTracksByIdRequest
  ): Promise<GetPlaylistTracksByIdResponse> {
    const res = await firstValueFrom(
      this.http.get<GetPlaylistTracksByIdResponse>(
        this.apiConfiguration.api_url +
          'playlists/' +
          playlistRequest.playlist_id +
          '/tracks?userId=' +
          this.userService.getUserId() +
          '&size=' +
          playlistRequest.limit +
          '&page=' +
          playlistRequest.page
      )
    );
    return res;
  }

  async addPlaylist(
    playlistFormRequest: AddPlaylistsRequest
  ): Promise<Playlist> {
    const body: AddPlaylistBodyRequest = {
      playlist: {
        name: playlistFormRequest.name,
        description: playlistFormRequest.description,
        public: false,
        collaborative: false,
      },
      strict: playlistFormRequest.strict,
      tags: playlistFormRequest.tags,
    };
    console.log(body.strict);
    const res = await firstValueFrom(
      this.http.post<Playlist>(
        this.apiConfiguration.api_url +
          'playlists?userId=' +
          this.userService.getUserId(),
        body
      )
    );
    return res;
  }

  async updatePlaylist(
    playlistFormRequest: UpdatePlaylistsRequest
  ): Promise<Playlist> {
    const body: AddPlaylistBodyRequest = {
      playlist: {
        name: playlistFormRequest.name,
        description: playlistFormRequest.description,
        public: false,
        collaborative: false,
      },
      strict: playlistFormRequest.strict,
      tags: playlistFormRequest.tags,
    };
    console.log(body.strict);
    const res = await firstValueFrom(
      this.http.put<Playlist>(
        this.apiConfiguration.api_url +
          'playlists/' +
          playlistFormRequest.playlist_id +
          '?userId=' +
          this.userService.getUserId(),
        body
      )
    );
    return res;
  }

  async deletePlaylist(deletePlaylistRequest: DeletePlaylistsRequest) {
    await firstValueFrom(
      this.http.delete(
        this.apiConfiguration.api_url +
          'playlists/' +
          deletePlaylistRequest.playlist_id +
          '?userId=' +
          this.userService.getUserId()
      )
    );
  }
}
