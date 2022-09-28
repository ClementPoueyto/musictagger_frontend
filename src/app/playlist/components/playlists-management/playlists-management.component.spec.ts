import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PlaylistsManagementComponent } from './playlists-management.component';

describe('PlaylistsManagementComponent', () => {
  let component: PlaylistsManagementComponent;
  let fixture: ComponentFixture<PlaylistsManagementComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ PlaylistsManagementComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(PlaylistsManagementComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
