import { HttpErrorResponse, HttpEvent, HttpHandler, HttpInterceptor, HttpRequest } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { MatSnackBar } from "@angular/material/snack-bar";
import { catchError, finalize, Observable } from "rxjs";

@Injectable()
export class HttpRequestInterceptor implements HttpInterceptor{

    constructor(private snackbar : MatSnackBar){}

    intercept(httpRequest: HttpRequest<any>, httpHandler: HttpHandler): Observable<HttpEvent<any>> {
        return httpHandler.handle(httpRequest).pipe(
            catchError((httpErrorResponse : HttpErrorResponse)=>{
                this.handleError(httpErrorResponse, httpRequest);
                throw httpErrorResponse;
            }), finalize(()=>{

            })
        )
    }

    private handleError(httpErrorResponse : HttpErrorResponse, httpRequest: HttpRequest<any>){
        this.snackbar.open(httpErrorResponse.error.message, 'Close', {
            duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
        });
    }

}