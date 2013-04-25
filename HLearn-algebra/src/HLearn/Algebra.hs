-- | This is the base module for the HLearn library.  It exports all the functions / data structures needed.

module HLearn.Algebra
    ( module HLearn.Algebra.Functions
    , module HLearn.Algebra.HVector
    , module HLearn.Algebra.HomTrainer
    , module HLearn.Algebra.Models.Lame
--     , module HLearn.Algebra.Morphism
    , module HLearn.Algebra.Structures.Groups
    , module HLearn.Algebra.Structures.MetricSpace
    , module HLearn.Algebra.Structures.Modules
    , module HLearn.Algebra.Structures.Triangles
    )
    where
          
import HLearn.Algebra.Functions
import HLearn.Algebra.HVector
import HLearn.Algebra.HomTrainer
import HLearn.Algebra.Models.Lame
-- import HLearn.Algebra.Morphism
import HLearn.Algebra.Structures.Groups
import HLearn.Algebra.Structures.MetricSpace
import HLearn.Algebra.Structures.Modules
import HLearn.Algebra.Structures.Triangles