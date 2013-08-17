/*  This file is part of libDAI - http://www.libdai.org/
 *
 *  Copyright (c) 2006-2011, The libDAI authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
 */


#include <iostream>
#include <dai/matlab/matlab.h>
#include "mex.h"
#include <dai/jtree.h>


using namespace std;
using namespace dai;

/* Input Arguments */
#define PSI_IN          prhs[0]
#define NR_IN           1

/* Output Arguments */
#define QMAP_OUT        plhs[0]
#define SCORE_OUT       plhs[1]
#define NR_OUT_MIN      1
#define NR_OUT_MAX      2

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[] ) {
    // Check for proper number of arguments
    if( (nrhs != NR_IN) || (nlhs < NR_OUT_MIN) || (nlhs > NR_OUT_MAX) )
    {
        mexErrMsgTxt("Usage: [mapState,score] = doinference(psi)\n\n"
        "\n"
        "INPUT:   psi        = linear cell array containing the factors\n"
        "                      (psi{i} should be a structure with a Member field\n"
        "                      and a P field).\n"
        "                      psi.P must be a column vector for singleton factor\n"
        "                      if psi.P is a matrix, the dimension of the matrix \n"
        "                      is the same as variable cardinality \n"
        "OUTPUT:  mapState   = linear array containing the MAP state (JTree).\n"
        "         logScore   = mapState score\n");
    }

    // Get psi and construct factorgraph
    vector<Factor> factors = mx2Factors(PSI_IN, 0);
    FactorGraph fg(factors);

//    fg.WriteToFile( "factorgraph_new.fg" );

    PropertySet opts;

    // Construct Junction Tree
    JTree jtmap( fg, opts("updates",string("HUGIN"))("inference",string("MAXPROD")) );

    // Initialize junction tree algorithm
    jtmap.init();

    // Run junction tree algorithm
    jtmap.run();

    // find map assignment
    std::vector<size_t> map_state;
    map_state = jtmap.findMaximum();

    if ( nlhs == 2 ) {
        // Compute maximum log-score
        double score = NAN;
        score = fg.logScore(map_state);

        // Hand over results to MATLAB
        SCORE_OUT = mxCreateDoubleMatrix(1,1,mxREAL);
        *(mxGetPr(SCORE_OUT)) = score;
    }

    // +1 because in MATLAB assignments start at 1
    for( size_t i = 0; i < map_state.size(); i++ ) {
        map_state[i] += 1;
    }

    // output map states
    QMAP_OUT = mxCreateNumericMatrix(map_state.size(), 1, mxUINT32_CLASS, mxREAL);
    uint32_T* qmap_p = reinterpret_cast<uint32_T *>(mxGetPr(QMAP_OUT));
    for (size_t n = 0; n < map_state.size(); ++n)
        qmap_p[n] = map_state[n];

    return;
}
