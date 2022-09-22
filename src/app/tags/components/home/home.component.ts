import { Component, OnInit } from '@angular/core';
import { LOCALSTORAGE_TOKEN_KEY } from 'src/app/app.module';
import { User } from '../../models/user.model';
import { UserService } from '../../services/user.service';
import {Dialog, DIALOG_DATA} from '@angular/cdk/dialog';
import { SpotifyAuthComponent } from 'src/app/spotify/component/spotify-auth/spotify-auth.component';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {

  constructor(private readonly userService : UserService, public dialog: Dialog) { }

  user? : User;

  ngOnInit(): void {
    const token = localStorage.getItem(LOCALSTORAGE_TOKEN_KEY);
    if(token){
      this.userService.user$.subscribe(user=>{
        if(user){
          this.user = user;
          if(!this.user.spotifyUser){
            this.openStreamingAuthDialog();
          }
        }
      })
      this.userService.getUser({jwt_token : token}).then(res=> console.log(res))
    }
  }

  openStreamingAuthDialog() {
    this.dialog.open(SpotifyAuthComponent, {
      disableClose : true,
      minWidth: '300px',
      
    });
  }

}
