import { Track } from 'src/app/tags/models/track.model';

export interface DeletePlaylistsRequest {
  playlist_id: number;
}

export interface GetPlaylistByIdRequest {
  playlist_id: number;
}

export interface GetPlaylistTracksByIdRequest {
  playlist_id: number;

  page: number;

  limit: number;
}

export interface GetPlaylistTracksByIdResponse {
  data: Track[];
  metadata: Metadata;
}

export interface Metadata {
  total: number;

  page: number;

  limit: number;
}

export interface AddPlaylistsRequest {
  name: string;

  description: string;

  tags: string[];

  strict: boolean;
}

export interface UpdatePlaylistsRequest {
  playlist_id: number;

  name: string;

  description: string;

  tags: string[];

  strict: boolean;
}

export interface AddPlaylistBodyRequest {
  playlist: {
    name: string;
    description: string;
    public: boolean;
    collaborative: boolean;
  };
  strict: boolean;
  tags: string[];
}
