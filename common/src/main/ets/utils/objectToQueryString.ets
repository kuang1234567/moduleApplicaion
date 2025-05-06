/**
 *将键值的对象转换成Query参数需要的字符串
 *
 */

export function objectToQueryString(paramsObj: Record<string, string>): string {
  let queryString = '?';
  Object.keys(paramsObj).forEach((key: string) => {
    // console.log('key:', key, 'value:', paramsObj[key]);
    queryString += `${encodeURIComponent(key)}=${encodeURIComponent(paramsObj[key])}&`;
  });
  return queryString.slice(0, -1); // 去掉最后一个多余的 '&'
}