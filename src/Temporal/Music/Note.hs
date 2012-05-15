{-# LANGUAGE TypeFamilies, FlexibleContexts, FlexibleInstances #-}

-- | This module gives an example of complete musical structure.
-- It defines the notion of note. 
module Temporal.Music.Note(
        -- * Types
        Note(..), note,
        Drum(..), drum, bam
) where

import Data.Finite
import Temporal.Music.Track(Time, Track, temp, accent)
import Temporal.Music.Volume
import Temporal.Music.Pitch

-- note

-- | 'Note' has volume, pitch and some timbral paramters.
data Note vol pch a = Note {
        noteVolume  :: Volume vol,
        notePitch   :: Pitch pch,
        noteParam   :: Maybe a
    } deriving (Show, Eq)


instance PitchLike (Note vol pch a) where
    type Step (Note vol pch a) = pch
    setPitch p a    = a{ notePitch = p }
    getPitch        = notePitch

instance VolumeLike (Note vol pch a) where
    type Level (Note vol pch a) = vol
    setVolume v a   = a{ noteVolume = v }
    getVolume       = noteVolume


-- | Combines functions 'fromLevel' and 'fromStep'. 
-- Timbral parameter is set to 'Nothing'.
note :: (HasDiap vol,  HasScale pch) => 
    vol -> pch -> Note vol pch a
note vol pch = Note (fromLevel vol) (fromStep pch) Nothing


-- drum

-- | 'Drum' has only pitch and some timbral paramters.
data Drum vol a = Drum {
        drumVolume  :: Volume vol,
        drumParam   :: Maybe a
    } deriving (Show, Eq)


instance VolumeLike (Drum vol a) where
    type Level (Drum vol a) = vol
    setVolume v a   = a{ drumVolume = v }
    getVolume       = drumVolume

-- | Lifts 'fromLevel' function to drums.
drum :: HasDiap vol => vol -> Drum vol a
drum vol = Drum (fromLevel vol) Nothing

-- | Constructs drum note with given accent. Level is set to medium value.
bam :: (Time t, HasDiap vol, Finite vol) => Accent -> Track t (Drum vol a)
bam a = accent a $ temp $ Drum mediumVolume Nothing


