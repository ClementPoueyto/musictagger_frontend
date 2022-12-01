import { Component, OnInit, OnDestroy, ChangeDetectorRef } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { AuthService } from '../../services/auth.service';
import { DomSanitizer } from '@angular/platform-browser';
import { MatIconRegistry } from '@angular/material/icon';
import { tokenGetter } from 'src/app/app.module';
import { MatSnackBar } from '@angular/material/snack-bar';
import { Subscription, firstValueFrom } from 'rxjs';
import { apiUrlLoginGoogle, googleLogoURL } from 'src/app/constants';
import { LoaderService } from 'src/app/shared/services/loader.service';




@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit, OnDestroy {

  api_url_login_google = apiUrlLoginGoogle;

  loginForm: FormGroup = new FormGroup({
    email: new FormControl(null, [Validators.required, Validators.email]),
    password: new FormControl(null, [Validators.required]),
  });

  routeSub: Subscription = new Subscription();
  loadingSub: Subscription = new Subscription();

  isLoading = true;
  constructor(
    private authService: AuthService,
    private router: Router,
    private matIconRegistry: MatIconRegistry,
    private domSanitizer: DomSanitizer,
    private route: ActivatedRoute,
    private snackbar: MatSnackBar,
    private loaderService: LoaderService,
    private ref: ChangeDetectorRef
  ) {
    this.matIconRegistry.addSvgIcon(
      "google-logo",
      this.domSanitizer.bypassSecurityTrustResourceUrl(googleLogoURL));
      

  }
  ngOnDestroy(): void {
    this.routeSub.unsubscribe();
    this.loadingSub.unsubscribe();
  }
  ngOnInit(): void {
    this.loadingSub = this.loaderService.loadingEvent.asObservable().subscribe(res=>{
      this.isLoading = res;
      this.ref.detectChanges();
    });
    this.routeSub = this.route.queryParams
      .subscribe(async params => {
        const token = tokenGetter();
        if (token) {
          firstValueFrom(this.authService.getToken()).then(tokenResponse => {
            if (tokenResponse) {
              this.router.navigate(['/']);
            }
          })
        }
        else {
          if (params["jwt"]) {
            await this.authService.loginSuccess(params["jwt"]);
          }
          else if (params["failure"]) {
            this.snackbar.open('Login failure : ' + params["message"], 'Close', {
              duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
            });
          }
        }
      }
      );
  }



  login() {
    if (!this.loginForm.valid) {
      return;
    }
    firstValueFrom(this.authService.login(this.loginForm.value));
  }

}
