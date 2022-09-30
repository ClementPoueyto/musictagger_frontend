import { HttpClient, HttpHeaders } from '@angular/common/http';
import { EventEmitter, Injectable } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { catchError, firstValueFrom, Observable, of } from 'rxjs';
import { AuthService } from 'src/app/authentication/services/auth.service';
import { API_URL } from 'src/app/constants';
import { Metadata } from '../models/metadata.model';
import { TaggedTrack } from '../models/tagged-track.model';
import { Track } from '../models/track.model';
import { GetTaggedTrackByTrackIdRequest, GetTagNamesRequest, GetTagNamesResponse, LikeTaggedTrackRequest, LikeTaggedTrackResponse, SearchTaggedTrackRequest, SearchTaggedTrackResponse } from './tag.interface';
import { TagRequest } from './user-interface';

@Injectable({
  providedIn: 'root'
})
export class TagService {

  metadata: Metadata = { total: 0, page: 0, limit: 50 }

  query: string = "";

  tags : string[] = [];
  selectedChip: 'like' | 'tags' = 'like'

  constructor(private readonly authService: AuthService, private http: HttpClient,
    private snackbar: MatSnackBar,) { }

  async searchTaggedTrack(searchTaggedTrackRequest: SearchTaggedTrackRequest): Promise<SearchTaggedTrackResponse> {
    const request = await this.authService.checkToken({ jwt_token: searchTaggedTrackRequest.jwt_token })
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.get<SearchTaggedTrackResponse>(API_URL + 'tags/pagination?userId=' + request.decoded.userId
      + (searchTaggedTrackRequest.tags?.length > 0 ? "&tags=" + searchTaggedTrackRequest.tags.join(',') : "" )+
        "&page=" + searchTaggedTrackRequest.page +
        "&size=" + searchTaggedTrackRequest.limit +
        (searchTaggedTrackRequest.query ? "&query=" + searchTaggedTrackRequest.query : "" )+
        (searchTaggedTrackRequest.onlyMetadata?"&onlyMetadata="+searchTaggedTrackRequest.onlyMetadata:""),
      { headers: headers }).pipe(
        catchError((err) => {
          this.snackbar.open('get TaggedTrack fail', 'Close', {
            duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
          });
          return of();
        }),),

    );
    this.metadata = res.metadata;
    this.query = searchTaggedTrackRequest.query;
    this.selectedChip = 'tags';
    this.tags = searchTaggedTrackRequest.tags;
    return res;
  }

  async getLikeTaggedTrack(likeTaggedTrackRequest: LikeTaggedTrackRequest): Promise<LikeTaggedTrackResponse> {
    const request = await this.authService.checkToken({ jwt_token: likeTaggedTrackRequest.jwt_token })
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.get<LikeTaggedTrackResponse>(API_URL + 'tags/like?userId=' + request.decoded.userId
      + "&page=" + likeTaggedTrackRequest.page + "&size=" + likeTaggedTrackRequest.limit,
      { headers: headers }).pipe(
        catchError(() => {
          this.snackbar.open('get TaggedTrack fail', 'Close', {
            duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
          });
          return of();
        }),),

    );
    this.metadata = res.metadata;
    this.selectedChip = 'like'

    return res;
  }

  async getTaggedTrackByTrackId(getTaggedTrackRequest: GetTaggedTrackByTrackIdRequest): Promise<TaggedTrack> {
    const request = await this.authService.checkToken({ jwt_token: getTaggedTrackRequest.jwt_token })
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.get<TaggedTrack>(API_URL + 'tags/tracks/' + getTaggedTrackRequest.trackId + '?userId=' + request.decoded.userId, { headers: headers }).pipe(
      catchError(() => {
        this.snackbar.open('get TaggedTrack fail', 'Close', {
          duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
        });
        return of();
      }),),

    );
    return res;
  }

  async getTagNames(getTagNamesRequest: GetTagNamesRequest): Promise<GetTagNamesResponse> {
    const request = await this.authService.checkToken({ jwt_token: getTagNamesRequest.jwt_token })
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.get<Array<string>>(API_URL + 'tags/names?userId=' + request.decoded.userId,
      { headers: headers }).pipe(
        catchError(() => {
          this.snackbar.open('get TagNames fail', 'Close', {
            duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
          });
          return of();
        }),),

    );
    return { tagNames: res };
  }

  async addTag(addTagRequest: TagRequest): Promise<TaggedTrack> {
    const request = await this.authService.checkToken({ jwt_token: addTagRequest.jwt_token })
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.post<TaggedTrack>(API_URL + 'tags?userId=' + request.decoded.userId
      , addTagRequest.body,
      { headers: headers }).pipe(
        catchError(() => {
          this.snackbar.open('add Tag fail', 'Close', {
            duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
          });
          return of();
        }),),

    );
    return res;
  }

  async deleteTag(deleteTagRequest: TagRequest): Promise<TaggedTrack> {
    const request = await this.authService.checkToken({ jwt_token: deleteTagRequest.jwt_token })
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.delete<TaggedTrack>(API_URL + 'tags?userId=' + request.decoded.userId
      , {
        headers: headers, body: deleteTagRequest.body
      },).pipe(
        catchError(() => {
          this.snackbar.open('add Tag fail', 'Close', {
            duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
          });
          return of();
        }),),

    );
    return res;
  }

}
