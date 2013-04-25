{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE StandaloneDeriving #-}

module HLearn.Models.Classifiers.NearestNeighbor
    where

import Control.Applicative
import qualified Data.Foldable as F
import Data.List

import HLearn.Algebra
import HLearn.Models.Distributions
import HLearn.Models.Classifiers.Common

-------------------------------------------------------------------------------
-- data structures

newtype NaiveNN container label dp = NaiveNN
    { getcontainer :: container (label,dp) }
--     deriving (Read,Show,Eq,Ord,Semigroup,Monoid,RegularSemigroup)
    
deriving instance (Show (container (label,dp))) => Show (NaiveNN container label dp)
    
-------------------------------------------------------------------------------
-- algebra
    
instance (Monoid (container (label,dp))) => Monoid (NaiveNN container label dp) where
    mempty = NaiveNN mempty
    mappend nn1 nn2 = NaiveNN $ getcontainer nn1 `mappend` getcontainer nn2

-------------------------------------------------------------------------------
-- model

instance 
    ( Applicative container
    , Monoid (container (label,dp))
    ) => HomTrainer (NaiveNN container label dp) 
        where
    type Datapoint (NaiveNN container label dp) = (label,dp) 
    train1dp ldp = NaiveNN $ pure ldp
    
-------------------------------------------------------------------------------
-- classification

instance (Probabilistic (NaiveNN container label dp)) where
    type Probability (NaiveNN container label dp) = Double

neighborList :: 
    ( F.Foldable container
    , MetricSpace ring dp
    , Ord ring
    ) => dp -> NaiveNN container label dp -> [(label,dp)]
neighborList dp (NaiveNN dps) = sortBy f $ F.toList dps
    where
        f (_,dp1) (_,dp2) = compare (distance dp dp1) (distance dp dp2)


instance 
    ( Ord label
    , F.Foldable container
    , MetricSpace (Probability (NaiveNN container label dp)) dp
--     , label ~ Datapoint (ResultDistribution (NaiveNN container label dp))
--     , Mean (ResultDistribution (NaiveNN container label dp))
--     , Module ring (ResultDistribution (NaiveNN container
--                                       (Datapoint (ResultDistribution (NaiveNN container label dp)))
--                                       dp))
    ) => Classifier (NaiveNN container label dp)
        where
    type Label (NaiveNN container label dp) = label
    type UnlabeledDatapoint (NaiveNN container label dp) = dp
    type ResultDistribution (NaiveNN container label dp) = Categorical label Double
              
    probabilityClassify nn dp = trainW (map (\(l,dp) -> (1,l)) $ take k $ neighborList dp nn)
        where
            k = 3