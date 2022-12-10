import { Injectable, Injector } from '@angular/core';
import { firstValueFrom } from 'rxjs';
import { Metadata } from '../models/metadata.model';
import { TaggedTrack } from '../models/tagged-track.model';
import {
  GetTaggedTrackByTrackIdRequest,
  GetTagNamesResponse,
  LikeTaggedTrackRequest,
  LikeTaggedTrackResponse,
  SearchTaggedTrackRequest,
  SearchTaggedTrackResponse,
} from './tag-request.interface';
import {
  SuggestionRequest,
  TagRequest,
} from '../../shared/services/user-interface';
import { CommonService } from 'src/app/shared/services/rest/common.service';
import { UserService } from 'src/app/shared/services/user.service';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root',
})
export class TagService extends CommonService {
  metadata: Metadata = { page: 0, limit: 50 };

  query = '';

  tags: string[] = [];
  selectedChip: 'like' | 'tags' = 'tags';

  public lastIdTrackSelected = '';

  constructor(
    protected override http: HttpClient,
    private userService: UserService
  ) {
    super(http);
  }

  async searchTaggedTrack(
    searchTaggedTrackRequest: SearchTaggedTrackRequest
  ): Promise<SearchTaggedTrackResponse> {
    const res = await firstValueFrom(
      this.http.get<SearchTaggedTrackResponse>(
        this.apiConfiguration.api_url +
          'tags?userId=' +
          this.userService.getUserId() +
          (searchTaggedTrackRequest.tags?.length > 0
            ? '&tags=' + searchTaggedTrackRequest.tags.join(',')
            : '') +
          '&page=' +
          searchTaggedTrackRequest.page +
          '&size=' +
          searchTaggedTrackRequest.limit +
          (searchTaggedTrackRequest.query
            ? '&query=' + searchTaggedTrackRequest.query
            : '') +
          (searchTaggedTrackRequest.onlyMetadata
            ? '&onlyMetadata=' + searchTaggedTrackRequest.onlyMetadata
            : '')
      )
    );
    this.metadata = res.metadata;
    this.query = searchTaggedTrackRequest.query;
    this.selectedChip = 'tags';
    this.tags = searchTaggedTrackRequest.tags;
    return res;
  }

  async getLikeTaggedTrack(
    likeTaggedTrackRequest: LikeTaggedTrackRequest
  ): Promise<LikeTaggedTrackResponse> {
    const res = await firstValueFrom(
      this.http.get<LikeTaggedTrackResponse>(
        this.apiConfiguration.api_url +
          'tags/like?userId=' +
          this.userService.getUserId() +
          '&page=' +
          likeTaggedTrackRequest.page +
          '&size=' +
          likeTaggedTrackRequest.limit
      )
    );
    this.metadata = res.metadata;
    this.selectedChip = 'like';

    return res;
  }

  async getTaggedTrackByTrackId(
    getTaggedTrackRequest: GetTaggedTrackByTrackIdRequest
  ): Promise<TaggedTrack> {
    const res = await firstValueFrom(
      this.http.get<TaggedTrack>(
        this.apiConfiguration.api_url +
          'tags/tracks/' +
          getTaggedTrackRequest.trackId +
          '?userId=' +
          this.userService.getUserId()
      )
    );
    return res;
  }

  async getTagNames(): Promise<GetTagNamesResponse> {
    const res = await firstValueFrom(
      this.http.get<Array<string>>(
        this.apiConfiguration.api_url +
          'tags/names?userId=' +
          this.userService.getUserId()
      )
    );
    return { tagNames: res };
  }

  async addTag(addTagRequest: TagRequest): Promise<TaggedTrack> {
    const res = await firstValueFrom(
      this.http.post<TaggedTrack>(
        this.apiConfiguration.api_url +
          'tags?userId=' +
          this.userService.getUserId(),
        addTagRequest.body
      )
    );
    return res;
  }

  async getSuggestions(
    suggestionRequest: SuggestionRequest
  ): Promise<string[]> {
    const res = await firstValueFrom(
      this.http.get<string[]>(
        this.apiConfiguration.api_url +
          'tracks/' +
          suggestionRequest.trackId +
          '/suggestions'
      )
    );
    return res;
  }

  async deleteTag(deleteTagRequest: TagRequest): Promise<TaggedTrack> {
    const res = await firstValueFrom(
      this.http.delete<TaggedTrack>(
        this.apiConfiguration.api_url +
          'tags?userId=' +
          this.userService.getUserId(),
        {
          body: deleteTagRequest.body,
        }
      )
    );
    return res;
  }
}
