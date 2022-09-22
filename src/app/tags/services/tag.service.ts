import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { catchError, firstValueFrom, of } from 'rxjs';
import { AuthService } from 'src/app/authentication/services/auth.service';
import { API_URL } from 'src/app/constants';
import { SearchTaggedTrackRequest, SearchTaggedTrackResponse } from './tag.interface';

@Injectable({
  providedIn: 'root'
})
export class TagService {

constructor(private readonly authService : AuthService, private http: HttpClient,
  private snackbar: MatSnackBar,) { }

  async searchTaggedTrack(searchTaggedTrackRequest: SearchTaggedTrackRequest): Promise<SearchTaggedTrackResponse> {
    const request = await this.authService.checkToken({jwt_token : searchTaggedTrackRequest.jwt_token})
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.get<SearchTaggedTrackResponse>(API_URL + 'tags/pagination?userId=' + request.decoded.userId
    +(searchTaggedTrackRequest.tags.length>0?"&tags="+searchTaggedTrackRequest.tags.join(','):""),
     { headers: headers }).pipe(
      catchError(() => {
        this.snackbar.open('get TaggedTrack fail', 'Close', {
          duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
        });
        return of();
      }),),

    );
    console.log(res)
    return res;
  }

}
