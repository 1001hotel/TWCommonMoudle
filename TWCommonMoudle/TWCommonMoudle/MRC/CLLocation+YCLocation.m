//
//  CLLocation+YCLocation.m
//  YCMapViewDemo
//
//  Created by gongliang on 13-9-16.
//  Copyright (c) 2013年 gongliang. All rights reserved.
//

#import "CLLocation+YCLocation.h"
#import <math.h>

void transform_earth_from_mars(double lat, double lng, double* tarLat, double* tarLng);
void transform_mars_from_baidu(double lat, double lng, double* tarLat, double* tarLng);
void transform_baidu_from_mars(double lat, double lng, double* tarLat, double* tarLng);
bool outOfChina(double lat, double lon);
double transformLat(double x, double y);
double transformLon(double x, double y);
double PI=3.14159265358979324;

@implementation CLLocation (YCLocation)

- (CLLocation*)locationMarsFromEarth
{
    double lat = 0.0;
    double lng = 0.0;
    transform_earth_from_mars(self.coordinate.latitude, self.coordinate.longitude, &lat, &lng);
    return [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lng)
                                         altitude:self.altitude
                               horizontalAccuracy:self.horizontalAccuracy
                                 verticalAccuracy:self.verticalAccuracy
                                           course:self.course
                                            speed:self.speed
                                        timestamp:self.timestamp];
}

- (CLLocation*)locationEarthFromMars
{
    // 二分法查纠偏文件
    // http://xcodev.com/131.html
    return nil;
}

- (CLLocation*)locationBaiduFromMars
{
    double lat = 0.0;
    double lng = 0.0;
    transform_mars_from_baidu(self.coordinate.latitude, self.coordinate.longitude, &lat, &lng);
    return [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lng)
                                         altitude:self.altitude
                               horizontalAccuracy:self.horizontalAccuracy
                                 verticalAccuracy:self.verticalAccuracy
                                           course:self.course
                                            speed:self.speed
                                        timestamp:self.timestamp];
}

- (CLLocation*)locationMarsFromBaidu
{
    double lat = 0.0;
    double lng = 0.0;
    transform_baidu_from_mars(self.coordinate.latitude, self.coordinate.longitude, &lat, &lng);
    return [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lng)
                                         altitude:self.altitude
                               horizontalAccuracy:self.horizontalAccuracy
                                 verticalAccuracy:self.verticalAccuracy
                                           course:self.course
                                            speed:self.speed
                                        timestamp:self.timestamp];
}



#pragma mark -
#pragma mark - mark

//GCJ-02(火星坐标)转GPS****************************************
- (CLLocationCoordinate2D)WorldGS2MarsGS:(CLLocationCoordinate2D)coordinate
{
    // a = 6378245.0, 1/f = 298.3
    // b = a * (1 - f)
    // ee = (a^2 - b^2) / a^2;
    const double a = 6378245.0;
    const double ee = 0.00669342162296594323;
    
    if (outOfChina(coordinate.latitude, coordinate.longitude))
    {
        return coordinate;
    }
    double wgLat = coordinate.latitude;
    double wgLon = coordinate.longitude;
    double dLat = transformLat(wgLon - 105.0, wgLat - 35.0);
    double dLon = transformLon(wgLon - 105.0, wgLat - 35.0);
    double radLat = wgLat / 180.0 * PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * PI);
    
    return CLLocationCoordinate2DMake(wgLat + dLat, wgLon + dLon);
}
//GPS转GCJ-02(火星坐标)****************************************
- (CLLocationCoordinate2D)MarsGS2WorldGS:(CLLocationCoordinate2D)coordinate
{
    double gLat = coordinate.latitude;
    double gLon = coordinate.longitude;
    CLLocationCoordinate2D marsCoor = [self WorldGS2MarsGS:coordinate];
    double dLat = marsCoor.latitude - gLat;
    double dLon = marsCoor.longitude - gLon;
    return CLLocationCoordinate2DMake(gLat - dLat, gLon - dLon);
}

// BD-09 坐标转换成 GCJ-02 坐标
- (CLLocationCoordinate2D)MarsGS2BaiduGS:(CLLocationCoordinate2D)coordinate
{
    double x_pi = PI * 3000.0 / 180.0;
    double x = coordinate.longitude, y = coordinate.latitude;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    double bd_lon = z * cos(theta) + 0.0065;
    double bd_lat = z * sin(theta) + 0.006;
    return CLLocationCoordinate2DMake(bd_lat, bd_lon);
}
// GCJ-02 坐标转换成 BD-09 坐标
- (CLLocationCoordinate2D)BaiduGS2MarsGS:(CLLocationCoordinate2D)coordinate
{
    double x_pi = PI * 3000.0 / 180.0;
    double x = coordinate.longitude - 0.0065, y = coordinate.latitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    double gg_lon = z * cos(theta);
    double gg_lat = z * sin(theta);
    return CLLocationCoordinate2DMake(gg_lat, gg_lon);
}

// BD-09 坐标转换成 WGS-84 坐标
- (CLLocationCoordinate2D)WorldGS2BaiduGS:(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D mars = [self WorldGS2MarsGS:coordinate];
    CLLocationCoordinate2D baidu = [self MarsGS2BaiduGS:mars];
    return baidu;
}
// WGS-84 坐标转换成 BD-09 坐标
- (CLLocationCoordinate2D)BaiduGS2WorldGS:(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D mars = [self BaiduGS2MarsGS:coordinate];
    CLLocationCoordinate2D world = [self MarsGS2WorldGS:mars];
    return world;
}
//// WGS-84 坐标转换成 Sogou 坐标
//- (CLLocationCoordinate2D)WorldGS2SogouGS:(CLLocationCoordinate2D)coordinate
//{
//    const double ee = 0.082271854224939184;
//    double lon = coordinate.longitude;
//    double lat = coordinate.latitude;
//    double dlon = [self rad:CLIP(lon, -360, 360)];
//    double dlat = [self rad:CLIP(lat, -90, 90)];
//    dlon = 6378206.4 * dlon;
//    double sinphi = sin(dlat);
//    double temp1, temp2;
//    if((temp1 = 1.0 + sinphi) == 0.0){
//        dlat = -1000000000;
//    }else if((temp2 = 1.0 - sinphi) == 0.0){
//        dlat = 1000000000;
//    }else{
//        double esinphi = ee * sinphi;
//        dlat = 3189103.2000000002 * log((temp1 / temp2) * pow((1.0 - esinphi) / (1.0 + esinphi), ee));
//    }
//    return CLLocationCoordinate2DMake(dlat, dlon);
//}
//
//// Sogou 坐标转换成 WGS-84 坐标
//- (CLLocationCoordinate2D)SogouGS2WorldGS:(CLLocationCoordinate2D)coordinate
//{
//    const double ee = 1.5707963267948966;
//    const double aa = 0.0033938814110493522;
//    double lon = coordinate.longitude;
//    double lat = coordinate.latitude;
//    double dlon = lon / 6378206.4;
//    double temp = -lat / 6378206.4;
//    double chi;
//    if(temp < -307){
//        chi = ee;
//    }else if(temp > 308){
//        chi = -ee;
//    }else{
//        chi = ee - 2 * atan(exp(temp));
//    }
//    double chi2 = 2 * chi;
//    double coschi2 = cos(chi2);
//    double dlat = chi + sin(chi2) * (aa + coschi2 * (1.3437644537757259E-005 + coschi2 * (7.2964865099246009E-008 + coschi2 * 4.4551470401894685E-010)));
//    double rlon = CLIP([self deg:dlon], -360, 360);
//    double rlat = CLIP([self deg:dlat], -90, 90);
//    return CLLocationCoordinate2DMake(rlat, rlon);
//}

//WGS-84 坐标转换成 墨卡托 坐标
- (CLLocationCoordinate2D)WorldGS2Mercator:(CLLocationCoordinate2D)coordinate
{
    double lon = coordinate.longitude*20037508.34/180;
    double lat = log(tan((90+coordinate.latitude)*M_PI/360))/(M_PI/180);
    lat = lat*20037508.34/180;
    return CLLocationCoordinate2DMake(lat, lon);
}

//墨卡托 坐标转换成 WGS-84 坐标
- (CLLocationCoordinate2D)Mercator2WorldGS:(CLLocationCoordinate2D)mercator
{
    double lon = mercator.longitude/20037508.34*180;
    double lat = mercator.latitude/20037508.34*180;
    lat = 180/M_PI*(2*atan(exp(lat*M_PI/180))-M_PI/2);
    return CLLocationCoordinate2DMake(lat, lon);
}


#pragma mark -
#pragma mark -  GPS坐标转BD-09
- (CLLocationCoordinate2D)gcj02Encrypt:(double)ggLat bdLon:(double)ggLon
{
    CLLocationCoordinate2D resPoint;
    double mgLat;
    double mgLon;
    
    if (outOfChina(ggLat, ggLon))
    {
        resPoint.latitude = ggLat;
        resPoint.longitude = ggLon;
        return resPoint;
    }

    
    double dLat = transformLat(ggLon - 105.0, ggLat - 35.0);
    double dLon = transformLon(ggLon - 105.0, ggLat - 35.0);
    
    double jzA = 6378245.0;
    double jzEE = 0.00669342162296594323;
    
    double radLat = ggLat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - jzEE * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((jzA * (1 - jzEE)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (jzA / sqrtMagic * cos(radLat) * M_PI);
    mgLat = ggLat + dLat;
    mgLon = ggLon + dLon;
    
    resPoint.latitude = mgLat;
    resPoint.longitude = mgLon;
    return resPoint;
}
-(CLLocationCoordinate2D)bd09Encrypt:(double)ggLat bdLon:(double)ggLon
{
    CLLocationCoordinate2D bdPt;
    double x = ggLon, y = ggLat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) + 0.000003 * cos(x * M_PI);
    bdPt.longitude = z * cos(theta) + 0.0065;
    bdPt.latitude = z * sin(theta) + 0.006;
    return bdPt;
}
//GPS坐标转BD-09(百度坐标)****************************************
- (CLLocationCoordinate2D)wgs84ToBd09:(CLLocationCoordinate2D)location
{
    CLLocationCoordinate2D gcj02Pt = [self gcj02Encrypt:location.latitude
                                                  bdLon:location.longitude];
    return [self MarsGS2WorldGS:[self bd09Encrypt:gcj02Pt.latitude bdLon:gcj02Pt.longitude]];
}


@end



// --- transform_earth_from_mars ---
// 参考来源：https://on4wp7.codeplex.com/SourceControl/changeset/view/21483#353936
// Krasovsky 1940
//
// a = 6378245.0, 1/f = 298.3
// b = a * (1 - f)
// ee = (a^2 - b^2) / a^2;
const double a = 6378245.0;
const double ee = 0.00669342162296594323;

bool transform_sino_out_china(double lat, double lon)
{
    if (lon < 72.004 || lon > 137.8347)
        return true;
    if (lat < 0.8293 || lat > 55.8271)
        return true;
    return false;
}

double transform_earth_from_mars_lat(double x, double y)
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs((int)x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

double transform_earth_from_mars_lng(double x, double y)
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs((int)x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}

void transform_earth_from_mars(double lat, double lng, double* tarLat, double* tarLng)
{
    if (transform_sino_out_china(lat, lng))
    {
        *tarLat = lat;
        *tarLng = lng;
        return;
    }
    double dLat = transform_earth_from_mars_lat(lng - 105.0, lat - 35.0);
    double dLon = transform_earth_from_mars_lng(lng - 105.0, lat - 35.0);
    double radLat = lat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    *tarLat = lat + dLat;
    *tarLng = lng + dLon;
}

// --- transform_earth_from_mars end ---
// --- transform_mars_vs_bear_paw ---
// 参考来源：http://blog.woodbunny.com/post-68.html
const double x_pi = M_PI * 3000.0 / 180.0;

void transform_mars_from_baidu(double gg_lat, double gg_lon, double *bd_lat, double *bd_lon)
{
    double x = gg_lon, y = gg_lat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    *bd_lon = z * cos(theta) + 0.0065;
    *bd_lat = z * sin(theta) + 0.006;
}

void transform_baidu_from_mars(double bd_lat, double bd_lon, double *gg_lat, double *gg_lon)
{
    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    *gg_lon = z * cos(theta);
    *gg_lat = z * sin(theta);
}




    
//    {         const double pi = 3.14159265358979324;
//        
//        //         // Krasovsky 1940         //         // a = 6378245.0, 1/f = 298.3         // b = a * (1 - f)         // ee = (a^2 - b^2) / a^2;         const double a = 6378245.0;         const double ee = 0.00669342162296594323;
//        
//        //         // World Geodetic System ==> Mars Geodetic System         public static void transform(double wgLat, double wgLon, out double mgLat, out double mgLon)         {             if (outOfChina(wgLat, wgLon))
//        
//        {                 mgLat = wgLat;                 mgLon = wgLon;                 return;             }             double dLat = transformLat(wgLon - 105.0, wgLat - 35.0);             double dLon = transformLon(wgLon - 105.0, wgLat - 35.0);             double radLat = wgLat / 180.0 * pi;             double magic = Math.Sin(radLat);             magic = 1 - ee * magic * magic;             double sqrtMagic = Math.Sqrt(magic);             dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);             dLon = (dLon * 180.0) / (a / sqrtMagic * Math.Cos(radLat) * pi);             mgLat = wgLat + dLat;             mgLon = wgLon + dLon;         }

    
double pi = 3.14159265358979324;

bool outOfChina(double lat, double lon)
{
    if (lon < 72.004 || lon > 137.8347)
        return true;
    if (lat < 0.8293 || lat > 55.8271)
        return true;
    return false;
}

double transformLat(double x, double y)
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return ret;
}
    
double transformLon(double x, double y)
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return ret;
}


