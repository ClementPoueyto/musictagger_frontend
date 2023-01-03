import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SpotifyRedirectionButttonComponent } from './spotify-redirection-buttton.component';

describe('SpotifyRedirectionButttonComponent', () => {
  let component: SpotifyRedirectionButttonComponent;
  let fixture: ComponentFixture<SpotifyRedirectionButttonComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ SpotifyRedirectionButttonComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(SpotifyRedirectionButttonComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
