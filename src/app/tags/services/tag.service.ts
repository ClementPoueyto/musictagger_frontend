import { HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { catchError, EMPTY, firstValueFrom, Observable, of } from 'rxjs';
import { CommonAuthService } from 'src/app/core/services/rest/common-auth.service';
import { Metadata } from '../models/metadata.model';
import { TaggedTrack } from '../models/tagged-track.model';
import { GetTaggedTrackByTrackIdRequest, GetTagNamesRequest, GetTagNamesResponse, LikeTaggedTrackRequest, LikeTaggedTrackResponse, SearchTaggedTrackRequest, SearchTaggedTrackResponse } from './tag.interface';
import { TagRequest } from './user-interface';

@Injectable({
  providedIn: 'root'
})
export class TagService extends CommonAuthService {

  metadata: Metadata = { total: 0, page: 0, limit: 50 }

  query: string = "";

  tags : string[] = [];
  selectedChip: 'like' | 'tags' = 'like'


  async searchTaggedTrack(searchTaggedTrackRequest: SearchTaggedTrackRequest): Promise<SearchTaggedTrackResponse> {
    const request = await this.authService.checkToken({ jwt_token: searchTaggedTrackRequest.jwt_token })
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.get<SearchTaggedTrackResponse>(this.apiConfiguration.api_url + 'tags?userId=' + request.decoded.userId
      + (searchTaggedTrackRequest.tags?.length > 0 ? "&tags=" + searchTaggedTrackRequest.tags.join(',') : "" )+
        "&page=" + searchTaggedTrackRequest.page +
        "&size=" + searchTaggedTrackRequest.limit +
        (searchTaggedTrackRequest.query ? "&query=" + searchTaggedTrackRequest.query : "" )+
        (searchTaggedTrackRequest.onlyMetadata?"&onlyMetadata="+searchTaggedTrackRequest.onlyMetadata:""),
      { headers: headers })

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
    const res = await firstValueFrom(this.http.get<LikeTaggedTrackResponse>(this.apiConfiguration.api_url + 'tags/like?userId=' + request.decoded.userId
      + "&page=" + likeTaggedTrackRequest.page + "&size=" + likeTaggedTrackRequest.limit,
      { headers: headers })

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
    const res = await firstValueFrom(this.http.get<TaggedTrack>(this.apiConfiguration.api_url + 'tags/tracks/' + getTaggedTrackRequest.trackId + '?userId=' + request.decoded.userId, { headers: headers }));
    return res;
  }

  async getTagNames(getTagNamesRequest: GetTagNamesRequest): Promise<GetTagNamesResponse> {
    const request = await this.authService.checkToken({ jwt_token: getTagNamesRequest.jwt_token })
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.get<Array<string>>(this.apiConfiguration.api_url + 'tags/names?userId=' + request.decoded.userId,
      { headers: headers })

    );
    return { tagNames: res };
  }

  async addTag(addTagRequest: TagRequest): Promise<TaggedTrack> {
    const request = await this.authService.checkToken({ jwt_token: addTagRequest.jwt_token })
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.post<TaggedTrack>(this.apiConfiguration.api_url + 'tags?userId=' + request.decoded.userId
      , addTagRequest.body,
      { headers: headers })
    );
    return res;
  }

  async deleteTag(deleteTagRequest: TagRequest): Promise<TaggedTrack> {
    const request = await this.authService.checkToken({ jwt_token: deleteTagRequest.jwt_token })
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.delete<TaggedTrack>(this.apiConfiguration.api_url + 'tags?userId=' + request.decoded.userId
      , {
        headers: headers, body: deleteTagRequest.body
      },)
    );
    return res;
  }

}
