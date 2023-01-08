import { Metadata } from '../models/metadata.model';
import { TaggedTrack } from '../models/tagged-track.model';

export interface SearchTaggedTrackRequest {
  page: number;

  limit: number;

  tags: string[];

  query: string;

  strict?: boolean;

  onlyMetadata?: boolean;
}

export interface SearchTaggedTrackResponse {
  data: TaggedTrack[];
  metadata: Metadata;
}

export interface LikeTaggedTrackRequest {
  page: number;

  limit: number;
}

export interface LikeTaggedTrackResponse {
  data: TaggedTrack[];
  metadata: Metadata;
}

export interface GetTaggedTrackByTrackIdRequest {
  trackId: string;
}

export interface GetTagNamesResponse {
  tagNames: string[];
}
