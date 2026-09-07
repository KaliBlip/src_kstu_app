// const buildUrl = 'https://kingthrive-com.stackstaging.com/api/v1';
// const asset_base_url = 'https://kingthrive-com.stackstaging.com';

// const asset_base_url = 'http://16.16.192.97';
// const buildUrl = 'http://16.16.192.97/api/v1';

// const buildUrl = 'http://10.0.2.2:8000/api/v1';
// const asset_base_url = 'http://10.0.2.2:8000';

const buildUrl = 'https://app.src-kstu.com/api/v1';
const asset_base_url = 'https://app.src-kstu.com';


const loginUrl = buildUrl + '/login';
const registerUrl = buildUrl + '/register';
const logoutUrl = buildUrl + '/logout';
const userUrl = buildUrl + '/me';
const forgotPasswordUrl = buildUrl + '/forgot-password';
const updateDpUrl = buildUrl + '/me/update-dp';
const updatePasswordUrl = buildUrl + '/update-password';

const noticeUrl = buildUrl + '/announcements/notice-board';
const trendingUrl = buildUrl + '/announcements/trending-news';
const announcementDetailUrl = buildUrl + '/announcement';

const likesUrl = buildUrl + '/post-interact/announcements';
const keyMomentsUrl = buildUrl + '/announcement/moments';

const mainCampusMapUrl = buildUrl + '/campus-map/main-campus-landmarks';
const adakoMapUrl = buildUrl + '/campus-map/adako-landmarks';
const camMapDetailUrl = buildUrl + '/campus-map/landmark/map';
const landmarkPlaces = buildUrl + '/campus-map/landmark/places';

// image-paths
const announcement_imgUri = asset_base_url + '/storage/announcement_imgs/';
const key_moment_uri = asset_base_url + '/storage/moment_imgs/';
const user_img_uri = asset_base_url + '/storage/user_imgs/';
const landmark_imgs = asset_base_url + '/storage/landmark_imgs/';

const serverError = "Server Error";
const unauthorized = "Unauthorized";
const somethingWentwrong = "Something went wrong, try again";