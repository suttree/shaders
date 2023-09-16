vec3 palette( in float t )
{
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 0.7, 0.4);
    vec3 d = vec3(0.00, 0.15, 0.20);

    return a + b*cos( 6.28318*(c*t+d) );
}

// 2d rotation matrix
mat2 Rot(float a) {
    float s=sin(a), c=cos(a);
    return mat2(c, -s, s, c);
}

// noise function
float Hash21(vec2 p) {
    p = fract(p*vec2(123.34, 456.21));
    p += dot(p, p+45.32);
    return fract(p.x*p.y);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    vec2 uv0 = uv;
    
    //uv = fract(uv) * 0.5;
    
    vec3 finalColour = vec3(0.0);
    
    uv *= .5;   
    for(float i = 0.0; i < 30.; i++) {
        //uv = fract(uv) * 0.5;
        
        //uv *= Rot(1.-iTime*.0025);
        //uv = fract(uv * 2.) - 1.;

        // distance to centre from current
        float d = length(uv) * exp(-length(uv0));

        d += smoothstep(.1, .65, sin(d*4. + iTime*.2));
        //d = abs(d);
        //d *= cos(uv0 *.2 * iTime*.4)*.2;
        //d -= pow(0.5 / d, 2.25);
        
        vec3 col = palette(length(uv0) - iTime*.25);
        
        float m = .025/d;
        col -= m;

        col += smoothstep(.1, .08, d);

        float rays = 1.-abs(uv.x * uv.y*20.);
        col -= rays;

        finalColour = col * d;
    }
    
    float t = iTime*.0025;
    for( float i=0.; i<1.; i+=1./4.0) {
        float depth = fract(i+t);
        float scale = mix(20., .5, depth);
        float fade = depth * smoothstep(1., .9, depth);
        finalColour *= scale * fade;
    }
    
    //uv = fract(uv) * .5;
    fragColor = vec4(finalColour,1.0);
}