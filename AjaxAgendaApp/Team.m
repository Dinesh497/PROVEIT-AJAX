//
//  Team.m
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 19-04-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import "Team.h"

@implementation Team

-(void) addPlayer:(Player*)Player{
    [_Players addObject:Player];
}

-(Player*) objectInPlayersAtIndex:(NSUInteger)index{
    return [_Players objectAtIndex:index];
}

@end
