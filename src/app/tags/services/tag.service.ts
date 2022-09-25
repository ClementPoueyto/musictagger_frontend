import { HttpClient, HttpHeaders } from '@angular/common/http';
import { EventEmitter, Injectable } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { catchError, firstValueFrom, Observable, of } from 'rxjs';
import { AuthService } from 'src/app/authentication/services/auth.service';
import { API_URL } from 'src/app/constants';
import { Metadata } from '../models/metadata.model';
import { LikeTaggedTrackRequest, LikeTaggedTrackResponse, SearchTaggedTrackRequest, SearchTaggedTrackResponse } from './tag.interface';

@Injectable({
  providedIn: 'root'
})
export class TagService {

  metadata : Metadata = { total : 0, page : 0, limit : 50}

  query : string = "";

  selectedChip : 'like' | 'tags' ='like'

constructor(private readonly authService : AuthService, private http: HttpClient,
  private snackbar: MatSnackBar,) { }

  async searchTaggedTrack(searchTaggedTrackRequest: SearchTaggedTrackRequest): Promise<SearchTaggedTrackResponse> {
    const request = await this.authService.checkToken({jwt_token : searchTaggedTrackRequest.jwt_token})
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.get<SearchTaggedTrackResponse>(API_URL + 'tags/pagination?userId=' + request.decoded.userId
    +(searchTaggedTrackRequest.tags?.length>0?"&tags="+searchTaggedTrackRequest.tags.join(','):""+
    "&page="+searchTaggedTrackRequest.page+
    "&size="+searchTaggedTrackRequest.limit+
    searchTaggedTrackRequest.query?"&query="+searchTaggedTrackRequest.query:""),
     { headers: headers }).pipe(
      catchError(() => {
        this.snackbar.open('get TaggedTrack fail', 'Close', {
          duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
        });
        return of();
      }),),

    );
    this.metadata = res.metadata;
    this.query = searchTaggedTrackRequest.query;
    this.selectedChip = 'tags'
    return res;
  }

  async getLikeTaggedTrack(likeTaggedTrackRequest: LikeTaggedTrackRequest): Promise<LikeTaggedTrackResponse> {
    const request = await this.authService.checkToken({jwt_token : likeTaggedTrackRequest.jwt_token})
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.get<LikeTaggedTrackResponse>(API_URL + 'tags/like?userId=' + request.decoded.userId
    +"&page="+likeTaggedTrackRequest.page+"&size="+likeTaggedTrackRequest.limit,
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

}
